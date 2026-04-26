import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/character_entity.dart';
import '../../../../domain/models/extensions/character_ui.dart';
import '../../../controllers/characters_view_model.dart';
import '../../../widgets/star_rating.dart';

class CharacterDetailsView extends StatelessWidget {
  final Character character;

  const CharacterDetailsView({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final viewModel = injector.get<CharactersViewModel>();

    return Watch((context) {
      // Pega o personagem atualizado da lista de estado
      final updatedCharacter = viewModel.charactersState.state.value.firstWhere(
        (c) => c.id == character.id,
        orElse: () => character,
      );

      return Scaffold(
        appBar: AppBar(
          title: Text(updatedCharacter.name),
          backgroundColor: updatedCharacter.rarity.color.withValues(alpha: 0.2),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.pushNamed(
                  AppRouteNames.characterCreate,
                  extra: updatedCharacter,
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabeçalho com o nome, nível e estrelas
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: BorderSide(
                    color: updatedCharacter.rarity.color,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: AppSpacing.paddingLg,
                  child: Column(
                    children: [
                      Text(
                        updatedCharacter.name,
                        style: context.textStyles.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: updatedCharacter.rarity.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Level ${updatedCharacter.level}',
                        style: context.textStyles.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      StarRating(stars: updatedCharacter.stars, size: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Informações principais (Classe, Raridade, Alinhamento)
              Text(
                'Informações',
                style: context.textStyles.titleLarge?.semiBold,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildInfoRow(
                context,
                'Classe',
                updatedCharacter.characterClass.displayName,
                icon: updatedCharacter.characterClass.icon,
                iconColor: updatedCharacter.characterClass.color,
              ),
              _buildInfoRow(
                context,
                'Raridade',
                updatedCharacter.rarity.displayName,
                iconColor: updatedCharacter.rarity.color,
              ),
              _buildInfoRow(
                context,
                'Alinhamento',
                updatedCharacter.alignment.displayName,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Atributos numéricos (Health, Attack, Threat)
              Text('Atributos', style: context.textStyles.titleLarge?.semiBold),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildAttributeCard(
                      context,
                      'Ameaça',
                      updatedCharacter.threat.toString(),
                      Icons.warning_amber_rounded,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildAttributeCard(
                      context,
                      'Ataque',
                      updatedCharacter.attack.toString(),
                      Icons.sports_mma,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _buildAttributeCard(
                      context,
                      'Vida',
                      updatedCharacter.health.toString(),
                      Icons.favorite,
                      Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textStyles.bodyLarge?.withColor(
              Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: iconColor),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                value,
                style: context.textStyles.bodyLarge?.semiBold.withColor(
                  iconColor ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: context.textStyles.titleMedium?.semiBold),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: context.textStyles.bodySmall?.withColor(
                Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
