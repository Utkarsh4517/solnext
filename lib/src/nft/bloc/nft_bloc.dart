import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'nft_event.dart';
part 'nft_state.dart';

class NftBloc extends Bloc<NftEvent, NftState> {
  NftBloc() : super(NftInitial()) {
    on<NftEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

