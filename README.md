# Convoy

## Install the dependencies

```sh
$ helm dependency update ./charts/convoy
```

## Installing the chart

```sh
$ helm --debug upgrade --install convoy ./charts/convoy --namespace=$NAMESPACE --set image.tag=$VERSION
```
