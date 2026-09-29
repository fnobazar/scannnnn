
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() => runApp(const ScannnApp());

class ScannnApp extends StatelessWidget {
  const ScannnApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'scannnn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF6C5CE7)), useMaterial3: true),
      home: const MainNav(),
    );
  }
}

class MainNav extends StatefulWidget {
  const MainNav({super.key});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int idx = 0;
  final List<Widget> pages = const [HomePage(), ScannerPage(), SearchPage(), AIAgentPage(), HistoryPage(), InventoryPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => setState(() => idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.smart_toy), label: 'AI Agent'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Stock'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('scannnn'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(child: ListTile(title: Text('Total Scans'), subtitle: Text('1,248'), trailing: Icon(Icons.qr_code, size: 40))),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12,
            children: [
              _dashCard(Icons.qr_code_scanner, 'Scan Now', Colors.deepPurple),
              _dashCard(Icons.search, 'Search Product', Colors.blue),
              _dashCard(Icons.smart_toy, 'AI Agent', Colors.orange),
              _dashCard(Icons.analytics, 'Analytics', Colors.green),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductPage())), child: const Text('Add Product Page (10)')),
          ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExportPage())), child: const Text('Export Page (13)')),
          ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())), child: const Text('Settings Page (14)')),
        ],
      ),
    );
  }
  static Widget _dashCard(IconData icon, String title, Color c) {
    return Card(color: c.withOpacity(0.1), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 36, color: c), const SizedBox(height: 8), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))]));
  }
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});
  @override
  State<ScannerPage> createState() => _ScannerPageState();
}
class _ScannerPageState extends State<ScannerPage> {
  String result = "Scan QR/Barcode";
  final controller = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner - Page 5'), actions: [IconButton(icon: const Icon(Icons.flash_on), onPressed: ()=>controller.toggleTorch()), IconButton(icon: const Icon(Icons.cameraswitch), onPressed: ()=>controller.switchCamera())]),
      body: Column(children: [
        Expanded(flex: 4, child: MobileScanner(controller: controller, onDetect: (cap){ final v = cap.barcodes.first.rawValue; if(v!=null) setState(()=>result=v); })),
        Expanded(flex: 1, child: Container(width: double.infinity, color: Colors.black87, padding: const EdgeInsets.all(16), child: Column(children: [const Text('Result:', style: TextStyle(color: Colors.white70)), SelectableText(result, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const SizedBox(height: 8), ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetailPage(code: result))), child: const Text('View Details'))]))),
      ]),
    );
  }
  @override
  void dispose() { controller.dispose(); super.dispose(); }
}

// FIXED SEARCH PAGE - No Iterable error
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  String q = "";
  final List<String> items = ["Amul Milk 1L - 8901030875871", "Parle-G - 8901719123456", "Coca Cola - 5449000000996", "Maggi - 8901058001122"];
  @override
  Widget build(BuildContext context) {
    final List<String> filtered = items.where((e) => e.toLowerCase().contains(q.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Search - Page 6')),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(12), child: TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search product, barcode...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (v)=>setState(()=>q=v))),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final String e = filtered[index];
              return Card(child: ListTile(title: Text(e), trailing: const Icon(Icons.arrow_forward), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductDetailPage(code: e)))));
            },
          ),
        ),
      ]),
    );
  }
}

class AIAgentPage extends StatefulWidget {
  const AIAgentPage({super.key});
  @override
  State<AIAgentPage> createState() => _AIAgentPageState();
}
class _AIAgentPageState extends State<AIAgentPage> {
  final ctrl = TextEditingController();
  final List<Map<String,String>> msgs = [{"role":"ai","text":"Hi! I am scannnn AI Agent \nAsk: What is 8901030875871? or Stock low products?"}];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Agent - Page 7')),
      body: Column(children: [
        Expanded(child: ListView.builder(itemCount: msgs.length, itemBuilder: (c,i){ final m=msgs[i]; return Align(alignment: m['role']=='ai'?Alignment.centerLeft:Alignment.centerRight, child: Card(color: m['role']=='ai'?Colors.deepPurple.shade50:null, child: Padding(padding: const EdgeInsets.all(12), child: Text(m['text']!)))); })),
        Padding(padding: const EdgeInsets.all(8), child: Row(children: [Expanded(child: TextField(controller: ctrl, decoration: InputDecoration(hintText: 'Ask AI...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(24))))), IconButton(icon: const Icon(Icons.send), onPressed: (){ if(ctrl.text.trim().isEmpty) return; setState((){ msgs.add({"role":"user","text":ctrl.text}); msgs.add({"role":"ai","text":"Analyzing ${ctrl.text}... Found 3 matching products."}); ctrl.clear(); }); })])),
      ]),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('History - Page 8')), body: ListView.builder(itemCount: 20, itemBuilder: (c,i)=>ListTile(leading: const Icon(Icons.history), title: Text('Scan ${8901000000000+i}'), subtitle: const Text('2 hours ago'), trailing: const Icon(Icons.chevron_right))));
}
class ProductDetailPage extends StatelessWidget {
  final String code;
  const ProductDetailPage({super.key, required this.code});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Product Detail - Page 9')), body: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(code, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 12), const Text('Name: Sample Product\nPrice: Rs.50\nStock: 24\nCategory: Grocery'), const SizedBox(height: 20), Row(children: [ElevatedButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const EditProductPage())), child: const Text('Edit')), const SizedBox(width: 12), ElevatedButton(onPressed: (){}, child: const Text('Sell'))])])));
}
class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Add Product - Page 10')), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [const TextField(decoration: InputDecoration(labelText: 'Barcode')), const TextField(decoration: InputDecoration(labelText: 'Name')), const TextField(decoration: InputDecoration(labelText: 'Price')), const SizedBox(height: 20), ElevatedButton(onPressed: (){}, child: const Text('Save Product'))])));
}
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Inventory - Page 11')), body: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemCount: 12, itemBuilder: (c,i)=>Card(child: Center(child: Text('Product ${i+1}\nStock: ${10+i}')))));
}
class EditProductPage extends StatelessWidget {
  const EditProductPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Edit Product - Page 12')), body: const Center(child: Text('Edit form here')));
}
class ExportPage extends StatelessWidget {
  const ExportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Export - Page 13')), body: ListView(children: const [ListTile(title: Text('Export as CSV'), trailing: Icon(Icons.download)), ListTile(title: Text('Export as Excel'), trailing: Icon(Icons.download)), ListTile(title: Text('Export as PDF'), trailing: Icon(Icons.download))]));
}
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Settings - Page 14')), body: ListView(children: [SwitchListTile(title: const Text('Dark Mode'), value: false, onChanged: (_){}), const ListTile(title: Text('Language')), ListTile(title: const Text('About - Page 16'), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const AboutPage())))]));
}
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Profile - Page 15')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [CircleAvatar(radius: 40), SizedBox(height: 12), Text('Chandan Jha'), Text('fnobazar Owner')])));
}
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('About - Page 16')), body: const Center(child: Text('scannnn v1.0\nBuilt with Flutter')));
}
