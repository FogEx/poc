Write-Output "===== Stopping connector module  ====="

Write-Output "1. Searching node"

$node_to_stop = $(docker container exec node-1 bash -c "bin/fogex rpc 'FogEx.Utils.Node.where_is(FogEx.Modules.Connector.MQTT.Supervisor) |> IO.puts()'")

Write-Output "2. Stoping $node_to_stop"

docker stop $node_to_stop
