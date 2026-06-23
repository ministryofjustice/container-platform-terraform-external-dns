sources:
  - service
  - ingress
  - gateway-httproute
interval: '${sync_interval}'
triggerLoopOnEvent: true
provider: aws
aws:
  region: eu-west-2
  zoneType: public
  batchChangeSize: 4000
  zonesCacheDuration: '${aws_zone_cache_duration}'
domainFilters:
%{ for d in domainFilters ~}
  - ${d}
%{ endfor ~}
rbac:
  create: true
  apiVersion: v1
serviceAccount:
  create: true
  name: external-dns-sa
txtPrefix: "${txtPrefix}"
txtOwnerId: ${cluster}
logLevel: "${loglevel}"
policy: sync
metrics:
  enabled: true
  serviceMonitor:
    enabled: true  
priorityClassName: system-cluster-critical
global:
  security:
    allowInsecureImages: true

extraArgs:
  exclude-record-types: AAAA

enableGatewayListenerSets: true  
