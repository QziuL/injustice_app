import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:injustice_app/core/di/dependency_injection.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/character_entity.dart';
import '../../../../domain/models/extensions/character_ui.dart';
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
    final isEditing = widget.character != null;
    final primaryColor = isEditing
        ? _selectedRarity.color
        : Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Personagem' : 'Novo Personagem',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.1),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveCharacter),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nome e Nível
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: BorderSide(color: primaryColor, width: 2),
                ),
                child: Padding(
                  padding: AppSpacing.paddingLg,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        style: context.textStyles.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelText: 'Nome do Personagem',
                          labelStyle: context.textStyles.titleMedium,
                          border: InputBorder.none,
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O nome é obrigatório';
                          }
                          return null;
                        },
                      ),
                      const Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _levelController,
                              decoration: const InputDecoration(
                                labelText: 'Nível',
                                icon: Icon(Icons.upgrade),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Requerido';
                                final num = int.tryParse(value);
                                if (num == null || num < 1 || num > 80)
                                  return '1-80';
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey.withValues(alpha: 0.3),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _starsController,
                              decoration: const InputDecoration(
                                labelText: 'Estrelas',
                                icon: Icon(Icons.star, color: Colors.amber),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Requerido';
                                final num = int.tryParse(value);
                                if (num == null || num < 1 || num > 14)
                                  return '1-14';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Classificações
              Text(
                'Classificação',
                style: context.textStyles.titleLarge?.semiBold,
              ),
              const SizedBox(height: AppSpacing.md),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Padding(
                  padding: AppSpacing.paddingLg,
                  child: Column(
                    children: [
                      DropdownButtonFormField<CharacterClass>(
                        value: _selectedClass,
                        decoration: InputDecoration(
                          labelText: 'Classe',
                          icon: Icon(
                            _selectedClass.icon,
                            color: _selectedClass.color,
                          ),
                          border: InputBorder.none,
                        ),
                        items: CharacterClass.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.displayName),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null)
                            setState(() => _selectedClass = value);
                        },
                      ),
                      const Divider(),
                      DropdownButtonFormField<CharacterRarity>(
                        value: _selectedRarity,
                        decoration: InputDecoration(
                          labelText: 'Raridade',
                          icon: Icon(
                            Icons.diamond,
                            color: _selectedRarity.color,
                          ),
                          border: InputBorder.none,
                        ),
                        items: CharacterRarity.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.displayName),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null)
                            setState(() => _selectedRarity = value);
                        },
                      ),
                      const Divider(),
                      DropdownButtonFormField<CharacterAlignment>(
                        value: _selectedAlignment,
                        decoration: const InputDecoration(
                          labelText: 'Alinhamento',
                          icon: Icon(Icons.balance),
                          border: InputBorder.none,
                        ),
                        items: CharacterAlignment.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.displayName),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null)
                            setState(() => _selectedAlignment = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Atributos de Combate
              Text(
                'Atributos de Combate',
                style: context.textStyles.titleLarge?.semiBold,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.orange.withValues(alpha: 0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        side: const BorderSide(color: Colors.orange, width: 1),
                      ),
                      child: Padding(
                        padding: AppSpacing.paddingSm,
                        child: TextFormField(
                          controller: _threatController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Ameaça',
                            alignLabelWithHint: true,
                            prefixIcon: Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange,
                            ),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) =>
                              value == null || value.isEmpty ? '?' : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.red.withValues(alpha: 0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        side: const BorderSide(color: Colors.red, width: 1),
                      ),
                      child: Padding(
                        padding: AppSpacing.paddingSm,
                        child: TextFormField(
                          controller: _attackController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Ataque',
                            alignLabelWithHint: true,
                            prefixIcon: Icon(
                              Icons.sports_mma,
                              color: Colors.red,
                            ),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) =>
                              value == null || value.isEmpty ? '?' : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Card(
                      color: Colors.green.withValues(alpha: 0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        side: const BorderSide(color: Colors.green, width: 1),
                      ),
                      child: Padding(
                        padding: AppSpacing.paddingSm,
                        child: TextFormField(
                          controller: _healthController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Vida',
                            alignLabelWithHint: true,
                            prefixIcon: Icon(
                              Icons.favorite,
                              color: Colors.green,
                            ),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) =>
                              value == null || value.isEmpty ? '?' : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              FilledButton.icon(
                onPressed: _saveCharacter,
                icon: const Icon(Icons.save),
                label: Text(
                  isEditing ? 'Salvar Alterações' : 'Criar Personagem',
                ),
                style: FilledButton.styleFrom(
                  padding: AppSpacing.paddingLg,
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
