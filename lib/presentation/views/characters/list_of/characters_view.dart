import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injustice_app/core/routes/app_routes.dart';
import 'widgets/characters_app_bar.dart';
import 'widgets/characters_body.dart';
import 'widgets/characters_floating_button.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/models/account_entity.dart';
import '../../../../domain/models/character_entity.dart';
import '../../../controllers/characters_view_model.dart';
import '../../../widgets/account_summary_card.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/loading_indicator.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Página de listagem de personagens
class CharactersView extends StatefulWidget {
  final Account account;

  const CharactersView({super.key, required this.account});

  @override
  State<CharactersView> createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
  late final CharactersViewModel _viewModel;
  Account get account => widget.account;

  @override
  void initState() {
    super.initState();
    _viewModel = injector.get<CharactersViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.commands.fetchCharacters();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _deleteCharacter(Character character) async {
    await _viewModel.deleteCharacterCommand.executeWith((id: character.id));

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${character.name} removido')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharactersAppBar(state: _viewModel.charactersState),
      drawer: AppDrawer(),
      body: Watch((context) {
        final isLoading =
            _viewModel.commands.getAllCharactersCommand.isExecuting.value;

        final characters = _viewModel.charactersState.sortedCharacters.value;

        return RefreshIndicator(
          onRefresh: () async {},
          child: CustomScrollView(
            slivers: [
              /// Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingMd,
                  child: AccountSummaryCard(account: account),
                ),
              ),

              /// Filtros
              SliverToBoxAdapter(child: FilterPanel(viewModel: _viewModel)),

              /// Conteúdo (loading | empty | lista)
              if (isLoading)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: LoadingIndicator(message: 'Carregando personagens...'),
                )
              else if (characters.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: const EmptyState(),
                )
              else
                SliverPadding(
                  padding: AppSpacing.paddingMd,
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final character = characters[index];
                      return CharacterListItem(
                        character: character,
                        onDelete: () => _deleteCharacter(character),
                        onTap: () {
                          context.pushNamed(
                            AppRouteNames.characterDetails,
                            extra: character,
                          );
                        },
                      );
                    }, childCount: characters.length),
                  ),
                ),
            ],
          ),
        );
      }),
      floatingActionButton: CharactersFab(viewModel: _viewModel),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.people_outline,
              size: 72,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Nenhum personagem encontrado',
              textAlign: TextAlign.center,
              style: context.textStyles.titleMedium?.semiBold,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Adicione seu primeiro personagem usando o botão +',
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium?.withColor(
                Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
