bundle: {
	_appName:      string @timoni(runtime:string:APP_NAME)
	_appNamespace: string @timoni(runtime:string:APP_NAMESPACE)

	apiVersion: "v1alpha1"
	name:       _appName
	instances: {
		redis: {
			module: {
				url:     "oci://ghcr.io/stefanprodan/modules/redis"
				version: "7.2.3"
			}
			namespace: _appNamespace
			values: maxmemory: 256
		}
		podinfo: {
			module: url:     "oci://ghcr.io/stefanprodan/modules/podinfo"
			module: version: "6.5.4"
			namespace: _appNamespace
			values: caching: {
				enabled:  true
				redisURL: "tcp://redis:6379"
			}
		}
	}
}
