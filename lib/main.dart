import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/portfolio_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PortfolioProvider()..loadAssets(),
      child: const CyberhexApp(),
    ),
  );
}

class CyberhexApp extends StatelessWidget {
  const CyberhexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyberhex FIIs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        primaryColor: const Color(0xFFFCEE09),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFCEE09),
          secondary: Color(0xFF00F0FF),
          tertiary: Color(0xFFFF003C),
          surface: Color(0xFF1A1A1A),
        ),
        textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme).copyWith(
          bodyMedium: GoogleFonts.rajdhani(color: Colors.white70, fontSize: 16),
          bodyLarge: GoogleFonts.rajdhani(color: Colors.white, fontSize: 18),
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('CYBERHEX FIIS', style: GoogleFonts.orbitron(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, letterSpacing: 2.0)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: provider.assets.isEmpty
          ? Center(
              child: Text('NENHUM ATIVO NA CARTEIRA', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.5)),
            )
          : ListView.builder(
              itemCount: provider.assets.length,
              itemBuilder: (context, index) {
                final asset = provider.assets[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1), 
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: ListTile(
                    title: Text(asset.ticker, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    subtitle: Text('Cotas: ${asset.quantity} | PM: R\$ ${asset.averagePrice.toStringAsFixed(2)}'),
                    trailing: asset.hasNewDocument 
                      ? Icon(Icons.warning, color: Theme.of(context).colorScheme.tertiary) // Neon badge (Magenta)
                      : null,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          // TODO: Open transaction form
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
