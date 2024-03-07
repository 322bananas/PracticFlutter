import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/nasa.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Future<Map<String, dynamic>> getNasaData() async {
  Uri url = Uri.parse('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=blQq9sXnVDpmOtyrDwBlvavFfDDENHb7DybgFcf3');
  final response = await http.get(url,);

  if(response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error: ${response.reasonPhrase}');
  }
}

abstract class NasaState{}
class NasaLoadingState extends NasaState{}
class NasaLoadedState extends NasaState {
  Nasa data;
  NasaLoadedState({required this.data});
}
class NasaErrorState extends NasaState{}


class NasaCubit extends Cubit<NasaState> {
  NasaCubit() : super(NasaLoadingState());

  Future<void> loadData() async {
    try {
      Map<String, dynamic> apiData = await getNasaData();
      Nasa nasaData = Nasa.fromJson(apiData);
      emit(NasaLoadedState(data: nasaData));
      return;
    } catch(e) {
      emit(NasaErrorState());
      return;
    }
  }
}

