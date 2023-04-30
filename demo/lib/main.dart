import 'package:fluent_ui/fluent_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      theme: kimappFluentTheme(
        componentHeight: 34,
        borderRadius: 12,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: ScaffoldPage.withPadding(
        content: SizedBox(
          width: 500,
          child: Column(
            children: [
              TextFormBox(),
              const SizedBox(height: 8),
              TextFormBox(
                placeholder: 'Testing Text Field',
              ),
              const SizedBox(height: 8),
              TextFormBox(
                placeholder: 'Testing Text Field',
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(FluentIcons.search),
                ),
              ),
              const SizedBox(height: 8),
              Button(
                onPressed: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Filtered HHH',
                    ),
                    IconButton(
                      icon: const Icon(FluentIcons.clear, size: 10),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FilledButton(
                child: const Text("New User"),
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              ProgressFilledButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(FluentIcons.save),
                    SizedBox(width: 8),
                    Text(
                      "New User",
                      style: TextStyle(
                        height: 1.12,
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              NumberBox(
                value: 0,
                mode: SpinButtonPlacementMode.inline,
                onChanged: (value) {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
