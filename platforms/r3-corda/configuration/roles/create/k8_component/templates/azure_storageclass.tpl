kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: {{ component_name }}
provisioner: kubernetes.io/azure-disk
reclaimPolicy: Retain
allowVolumeExpansion: true
parameters:
  storageaccounttype: Premium_LRS
  kind: Managed
