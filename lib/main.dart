import 'package:Nasaproject/request/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const NasaApp());
}

class NasaApp extends StatefulWidget {
  const NasaApp({super.key});

  @override
  State<NasaApp> createState() => _NasaAppState();
}

bool _icon = false;

IconData light = Icons.brightness_5;
IconData dark = Icons.brightness_3;

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);

class _NasaAppState extends State<NasaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: _icon ? darkTheme : lightTheme,
        home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          centerTitle: true,
          title: const Text("Марс Фото", style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
           color: Colors.white
         )),
         actions: [
           IconButton(onPressed: () {
              setState(() {
               _icon = !_icon;
              });
           }, icon: Icon(_icon ? dark : light))
         ],
        ),
       body: BlocProvider(
          create: (BuildContext context) => NasaCubit(),
          child: BlocBuilder<NasaCubit, NasaState>(builder: (context, state) {
           if (state is NasaLoadingState) {
             BlocProvider.of<NasaCubit>(context).loadData();
             return const Center(child: CircularProgressIndicator());
           }
           if (state is NasaLoadedState) {
             return ListView.builder(
               itemCount: state.data.photos!.length,
               itemBuilder: (context, index) {
                  return Container(
                    height: 200,
                    width: 200,
                    child: Image.network(state.data.photos![index].imgSrc!),
                  );
                },
             );
            }
           if (state is NasaErrorState) {
             return const Center(child: Text("Произошла непредвиденная ошибка"));
           }
           return const Text("");
         },),
       )
     )
    );
  }
}
