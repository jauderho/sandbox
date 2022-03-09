
SAP strawman stack

```mermaid
  graph TD;
  User-->Firewall;
  Firewall-->Proxy;
  Firewall-->VPN;
  Proxy-->F5;
  VPN-->F5;
  F5-->WebDispatcher;
  WebDispatcher-->App;
  WebDispatcher-->ASCS/ERS;
  App-->HANA
  HANA-->HANA_DR
```
