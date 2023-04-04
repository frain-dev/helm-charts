helm --debug upgrade --install convoy ./charts/convoy
helm --debug upgrade --install stream ./charts/stream
helm --debug upgrade --install worker ./charts/worker
helm --debug upgrade --install scheduler ./charts/scheduler