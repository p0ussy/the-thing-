import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'dart:typed_data';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IDCardPage(),
    );
  }
}

class IDCardPage extends StatefulWidget {
  @override
  _IDCardPageState createState() => _IDCardPageState();
}

class _IDCardPageState extends State<IDCardPage> {
  late Timer _timer;
  String _currentTime = '';
  Uint8List? _uploadedImage;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          '${now.year}.${_formatNumber(now.month)}.${_formatNumber(now.day)}. ${_formatNumber(now.hour)}:${_formatNumber(now.minute)}:${_formatNumber(now.second)}';
    });
  }

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _uploadedImage = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  centerTitle: true, // Ensures the title is centered
  title: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.grey[200],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min, // Ensures the row is tightly fitted
      children: [
        _buildTabButton('신분증', isActive: true),
        _buildTabButton('자격증', isActive: false),
      ],
    ),
  ),
  leading: Builder(
    builder: (context) => IconButton(
      icon: Icon(Icons.menu, color: Colors.black),
      onPressed: () => Scaffold.of(context).openDrawer(),
    ),
  ),
),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Add Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Live Timestamp
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      _currentTime,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Card Centered
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        width: 300,
                        height: 500,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Expanded(
                              child: _uploadedImage != null
                                  ? Image.memory(
                                      _uploadedImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/sample_card.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '⚠️ 법적 효력 안내',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Left Arrow (Aligned Near Edges)
                    Positioned(
                      left: 10,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
                        onPressed: () {
                          // Handle left navigation (if any)
                        },
                      ),
                    ),

                    // Right Arrow (Aligned Near Edges)
                    Positioned(
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        onPressed: () {
                          // Handle right navigation (if any)
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // QR Menu
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQRButton(
                    icon: Icons.qr_code,
                    label: '나의 QR',
                    onPressed: () {
                      // Handle "My QR" button press
                    },
                  ),
                  _buildQRButton(
                    icon: Icons.qr_code_scanner,
                    label: 'QR 촬영',
                    onPressed: () {
                      // Handle "Scan QR" button press
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isActive ? Colors.white : Colors.transparent,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.black : Colors.grey,
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildQRButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.blue),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(color: Colors.blue, fontSize: 12),
        ),
      ],
    );
  }
}
