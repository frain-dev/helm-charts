# Installing the chart

```sh
helm --debug upgrade --install convoy ./convoy --namespace=$NAMESPACE --set image.tag=$VERSION
```
