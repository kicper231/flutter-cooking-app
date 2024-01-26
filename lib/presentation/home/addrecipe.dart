import 'package:flutter/material.dart';

class AddRecipe extends StatelessWidget {
  const AddRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final List<String> _categories = [
      'Deser',
      'Śniadanie',
      'Obiad',
      'Kolacja',
      'Przekąska'
    ]; // Dodaj swoje kategorie

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj Przepis'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tytuł przepisu',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać tytuł przepisu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Kategoria przepisu',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Logika zmiany kategorii
                },
                validator: (value) =>
                    value == null ? 'Proszę wybrać kategorię' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Składniki',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać składniki';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Opis przygotowania',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Proszę wpisać opis przygotowania';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Miejsce na Twoją logikę dodawania zdjęć
                },
                child: const Text('Dodaj zdjęcie'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Logika zapisu przepisu
                  }
                },
                child: const Text('Zapisz przepis'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
