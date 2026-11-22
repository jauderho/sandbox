"""Install bbot's dependencies for a fixed set of modules, and nothing else.

`bbot --install-all-deps` covers every module, including output sinks
(kafka, mongo, neo4j, ...) that ARTEX never uses. This resolves the given
scan modules the way a real scan would (adding the internal modules and the
json/txt outputs ARTEX's bbot-recon skill writes) and hands exactly that set
to bbot's own dependency installer. Unlike a --dry-run scan it runs no module
setup(), so nothing else (nuclei templates, wordlists) is fetched.

--skip drops whole modules whose tools the image provides itself;
--skip-common drops one of bbot's shared dependencies (e.g. chromium) from
every module that declares it.

usage: bbot-deps.py MODULE[,MODULE...] [--skip MODULE,...] [--skip-common DEP,...]
"""

import argparse
import asyncio
import sys

from bbot.scanner import Scanner


async def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("modules")
    parser.add_argument("--skip", default="")
    parser.add_argument("--skip-common", default="")
    args = parser.parse_args()

    modules = [m for m in args.modules.split(",") if m]
    skip = {m for m in args.skip.split(",") if m}
    skip_common = {d for d in args.skip_common.split(",") if d}

    scan = Scanner("example.com", modules=modules, output_modules=["json", "txt"])
    wanted = sorted(set(scan.preset.modules) - skip)

    preloaded = scan.helpers.depsinstaller.all_modules_preloaded
    for name in wanted:
        deps = preloaded[name]["deps"]
        dropped = skip_common.intersection(deps["common"])
        if dropped:
            deps["common"] = [d for d in deps["common"] if d not in dropped]
            print(f"{name}: not installing shared deps {','.join(sorted(dropped))}", flush=True)
    for name in wanted:
        leftover = skip_common.intersection(scan.helpers.depsinstaller.all_modules_preloaded[name]["deps"]["common"])
        if leftover:
            print(f"{name}: could not drop {','.join(sorted(leftover))}", file=sys.stderr)
            return 1
    print(f"installing dependencies for {len(wanted)} modules: {','.join(wanted)}", flush=True)

    succeeded, failed = await scan.helpers.depsinstaller.install(*wanted)
    if failed:
        print(f"failed: {','.join(sorted(failed))}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(asyncio.run(main()))
