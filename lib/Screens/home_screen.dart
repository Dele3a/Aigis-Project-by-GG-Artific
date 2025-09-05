import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      Navigator.pushNamed(context, '/analysis', arguments: pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Aigis AI',
          style: TextStyle(
            fontFamily: 'Orbitron',
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.black, Color(0xFF141414)],
            center: Alignment(0, -0.3),
            radius: 1.2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Futuristic Logo
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.6),
                      blurRadius: 25,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 60,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Your AI Guardian",
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 18,
                  color: Colors.amber,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 50),

              // Upload Image Button
              _buildNeonButton(
                context,
                icon: Icons.image,
                text: "Upload Image",
                onPressed: () => _pickImage(context, ImageSource.gallery),
              ),
              const SizedBox(height: 25),

              // Take Picture Button
              _buildNeonButton(
                context,
                icon: Icons.camera_alt,
                text: "Take Picture",
                onPressed: () => _pickImage(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Neon Button Builder
  Widget _buildNeonButton(BuildContext context,
      {required IconData icon,
        required String text,
        required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.amber.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 230,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.amber, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.7),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.amber, size: 22),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 16,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
