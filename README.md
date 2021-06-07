# Galital

To install Galital Validator node run

```
wget -O galital.sh https://raw.githubusercontent.com/fxpy/galital/main/install-galital.sh && chmod +x galital.sh && ./galital.sh
```

to obtain Session key run

```
curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9933
```
