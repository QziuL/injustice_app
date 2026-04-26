import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:injustice_app/core/di/dependency_injection.dart';

import '../../../../domain/models/character_entity.dart';
import '../../../controllers/characters_view_model.dart';

class CharacterCreateView extends StatefulWidget {
  final Character? character;

  const CharacterCreateView({super.key, this.character});

  @override
  State<CharacterCreateView> createState() => _CharacterCreateViewState();
}

class _CharacterCreateViewState extends State<CharacterCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _levelController = TextEditingController(text: '1');
  final _threatController = TextEditingController(text: '0');
  final _attackController = TextEditingController(text: '0');
  final _healthController = TextEditingController(text: '0');
  final _starsController = TextEditingController(text: '1');

  CharacterClass _selectedClass = CharacterClass.poderoso;
  CharacterRarity _selectedRarity = CharacterRarity.prata;
  CharacterAlignment _selectedAlignment = CharacterAlignment.heroi;

  late CharactersViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = injector.get<CharactersViewModel>();

    if (widget.character != null) {
      final c = widget.character!;
      _nameController.text = c.name;
      _levelController.text = c.level.toString();
      _threatController.text = c.threat.toString();
      _attackController.text = c.attack.toString();
      _healthController.text = c.health.toString();
      _starsController.text = c.stars.toString();

      _selectedClass = c.characterClass;
      _selectedRarity = c.rarity;
      _selectedAlignment = c.alignment;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _levelController.dispose();
    _threatController.dispose();
    _attackController.dispose();
    _healthController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  void _saveCharacter() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final isEditing = widget.character != null;

      final newCharacter = Character(
        id: isEditing
            ? widget.character!.id
            : now.millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        characterClass: _selectedClass,
        rarity: _selectedRarity,
        level: int.parse(_levelController.text),
        threat: int.parse(_threatController.text),
        attack: int.parse(_attackController.text),
        health: int.parse(_healthController.text),
        stars: int.parse(_starsController.text),
        alignment: _selectedAlignment,
        createdAt: isEditing ? widget.character!.createdAt : now,
        updatedAt: now,
      );

      _viewModel.commands.addCharacter(newCharacter);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.character != null ? 'Edit Character' : 'New Character',
        ),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveCharacter),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CharacterClass>(
                value: _selectedClass,
                decoration: const InputDecoration(labelText: 'Class'),
                items: CharacterClass.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.displayName),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedClass = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CharacterRarity>(
                value: _selectedRarity,
                decoration: const InputDecoration(labelText: 'Rarity'),
                items: CharacterRarity.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.displayName),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRarity = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CharacterAlignment>(
                value: _selectedAlignment,
                decoration: const InputDecoration(labelText: 'Alignment'),
                items: CharacterAlignment.values
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.displayName),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedAlignment = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _levelController,
                      decoration: const InputDecoration(labelText: 'Level'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final num = int.tryParse(value);
                        if (num == null || num < 1 || num > 80) {
                          return '1-80';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _starsController,
                      decoration: const InputDecoration(labelText: 'Stars'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final num = int.tryParse(value);
                        if (num == null || num < 1 || num > 14) {
                          return '1-14';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _threatController,
                      decoration: const InputDecoration(labelText: 'Threat'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _attackController,
                      decoration: const InputDecoration(labelText: 'Attack'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _healthController,
                      decoration: const InputDecoration(labelText: 'Health'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null) return 'Invalid';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveCharacter,
                child: Text(
                  widget.character != null
                      ? 'Save Changes'
                      : 'Create Character',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
