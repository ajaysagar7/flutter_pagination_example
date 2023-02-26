import 'package:flutter/material.dart';
import 'package:flutter_pagination/models/store_model.dart';
import 'package:flutter_pagination/providers/store_provider.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<StoreProvider>(context, listen: false)
            .getStoreLists(isInitialRefresh: false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Store Screen"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    context
                        .read<StoreProvider>()
                        .getStoreLists(isInitialRefresh: true);
                  },
                  icon: const Icon(Icons.refresh_rounded)),
              const SizedBox(
                width: 5,
              ),
              Text(context.watch<StoreProvider>().storeLists.length.toString())
            ],
          )
        ],
      ),
      body: Consumer<StoreProvider>(builder: (context, provider, _) {
        if (provider.state == Storestate.initial ||
            provider.state == Storestate.loading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        } else if (provider.state == Storestate.loaded) {
          // return ListView.builder(
          //     itemCount: provider.storeLists.length,
          //     itemBuilder: (c, i) {
          //       StoreModel model = provider.storeLists[i];
          //       return Text(model.title.toString());
          //     });
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: provider.storeLists.length,
                    itemBuilder: (c, i) {
                      StoreModel model = provider.storeLists[i];
                      return Column(
                        children: [
                          Image.network(
                            model.image.toString(),
                            height: 250,
                            width: 250,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(model.title.toString())
                        ],
                      );
                    }),
              ),
              const SizedBox(
                height: 20.0,
              ),
              provider.isRefreshing == true
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                        strokeWidth: 5,
                      ),
                    )
                  : Container()
            ],
          );
        } else if (provider.state == Storestate.failed) {
          return Center(
            child: Text(provider.errorMessage.toString()),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
