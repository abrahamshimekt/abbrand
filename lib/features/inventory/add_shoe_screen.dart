import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddShoeScreen extends StatefulWidget {
  const AddShoeScreen({super.key});

  @override
  State<AddShoeScreen> createState() => _AddShoeScreenState();
}

class _AddShoeScreenState extends State<AddShoeScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final brandController = TextEditingController();
  final sizeController = TextEditingController();
  final colorController = TextEditingController();
  final quantityController = TextEditingController();
  final buyingController = TextEditingController();
  final sellingController = TextEditingController();

  bool isSaving = false;
  File? imageFile;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  Future<String?> uploadImage() async {
    if (imageFile == null) return null;

    final supabase = Supabase.instance.client;

    final fileName = 'shoe_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage.from('shoe-images').upload(fileName, imageFile!);

    return supabase.storage.from('shoe-images').getPublicUrl(fileName);
  }

  Future<void> saveShoe() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => isSaving = true);

      final imageUrl = await uploadImage();

      await Supabase.instance.client.from('shoes').insert({
        'name': nameController.text.trim(),
        'brand': brandController.text.trim(),
        'size': sizeController.text.trim(),
        'color': colorController.text.trim(),
        'quantity': int.tryParse(quantityController.text) ?? 0,
        'buying_price': double.tryParse(buyingController.text) ?? 0,
        'selling_price': double.tryParse(sellingController.text) ?? 0,
        'image_url': imageUrl,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Shoe added successfully')));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isSaving = false);
    }
  }

  Widget field(
    String label, {
    TextEditingController? controller,
    TextInputType? type,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? "$label required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Add New Shoe"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// IMAGE CARD
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: InkWell(
                onTap: pickImage,
                borderRadius: BorderRadius.circular(18),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 220,
                  child: imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Tap to add shoe image",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BASIC INFO CARD
            _sectionCard(
              title: "Basic Info",
              children: [
                field("Shoe Name", controller: nameController),
                field("Brand", controller: brandController),
                field("Color", controller: colorController),
              ],
            ),

            const SizedBox(height: 16),

            /// DETAILS CARD
            _sectionCard(
              title: "Stock Details",
              children: [
                Row(
                  children: [
                    Expanded(child: field("Size", controller: sizeController)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: field(
                        "Quantity",
                        controller: quantityController,
                        type: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// PRICING CARD
            _sectionCard(
              title: "Pricing",
              children: [
                field(
                  "Buying Price",
                  controller: buyingController,
                  type: TextInputType.number,
                ),
                field(
                  "Selling Price",
                  controller: sellingController,
                  type: TextInputType.number,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// SAVE BUTTON
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveShoe,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Save Shoe", style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
