const net = require('net');

const client = net.createConnection({path:'/tmp/server.sock'}, () => {
  //'connect' listener
  console.log('connected to server');
  client.write('world!');
});

client.on('data', (data) => {
  console.log(data.toString());
  client.end();
});

client.on('end', () => {
  console.log('disconnected from server');
});
