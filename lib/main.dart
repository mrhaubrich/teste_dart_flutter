import 'package:flutter/material.dart';
import 'package:teste_dart_flutter/teste.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Teste Wrapper'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // FutureBuilder(
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return ListTile(
            //         title: Text(
            //           snapshot.data!.foto,
            //         ),
            //         leading: CircleAvatar(
            //           backgroundImage: NetworkImage(
            //             snapshot.data!.foto,
            //           ),
            //         ),
            //       );
            //     } else if (snapshot.hasError) {
            //       return Text(snapshot.error.toString());
            //     }
            //     return const CircularProgressIndicator();
            //   },
            //   future: Client.instance.client.getFoto(),
            // ),
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          snapshot.data![index].nome,
                        ),
                        subtitle: Text(
                          snapshot.data![index].email,
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data![index].foto.url,
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const CircularProgressIndicator();
              },
              future: Client.instance.client.getUsuarios(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
