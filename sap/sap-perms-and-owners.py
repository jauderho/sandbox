import os
import sys
import stat
import json
import argparse
from pathlib import Path
from xml.etree.ElementTree import Element, SubElement, tostring

def test_permissions(target, expected_permissions):
    result = {}
    try:
        st = os.stat(target)
    except FileNotFoundError:
        result["message"] = f"Target {target} does not exist."
        return result

    permissions = stat.S_IMODE(st.st_mode)

    owner = st.st_uid
    group = st.st_gid

    if permissions == int(expected_permissions, 8):
        result["message"] = f"Correct permissions for {target}: owner ({owner}) has read-write, group ({group}) has read, others have none."
    else:
        result["message"] = f"Incorrect permissions for {target}: owner ({owner}) should have read-write (6), group ({group}) should have read (4), others should have none (0)."
    
    return result

parser = argparse.ArgumentParser(description="Test SAP directory and file permissions and output the results in various formats.")
parser.add_argument("--sid", default=None, help="System ID of the SAP system (optional). If provided, the script will test the permissions for directories and files with the SID variable in the path.")
parser.add_argument("--output", choices=["json", "xml"], default="plaintext", help="Output format. Choices: plaintext (default), json, xml. Determines the format in which the results will be displayed.")

args = parser.parse_args()

sid = args.sid
output_format = args.output

sap_permissions = {
    "/usr/sap": "750",
    "/usr/sap/trans": "770",
    "/usr/sap/trans/tmp": "777",
    "/usr/sap/trans/cofiles": "770",
    "/usr/sap/trans/data": "770",
    "/usr/sap/trans/EPS/in": "770",
    "/usr/sap/trans/bin": "770"
}

if sid is not None:
    sap_permissions.update({
        f"/usr/sap/{sid}": "750",
        f"/usr/sap/{sid}/trans": "770",
        f"/usr/sap/{sid}/trans/tmp": "777",
        f"/usr/sap/{sid}/trans/cofiles": "770",
        f"/usr/sap/{sid}/trans/data": "770",
        f"/usr/sap/{sid}/trans/EPS/in": "770",
        f"/usr/sap/{sid}/trans/bin": "770"
    })

results = []

for target, expected_permissions in sap_permissions.items():
    result = test_permissions(target, expected_permissions)
    results.append(result)

if output_format == "json":
    print(json.dumps(results, indent=2))
elif output_format == "xml":
    xml_root = Element("results")
    for result in results:
        xml_result = SubElement(xml_root, "result")
        xml_result.text = result["message"]
    print(tostring(xml_root, encoding="unicode"))
else:
    for result in results:
        print(result["message"])
