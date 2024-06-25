import 'package:solana/solana.dart';

final solclient = SolanaClient(
  rpcUrl: Uri.parse('https://api.devnet.solana.com'),
  websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
);

final rpcClient = RpcClient('https://api.devnet.solana.com');
