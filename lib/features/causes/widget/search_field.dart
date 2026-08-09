import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/filter_providers.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({super.key});

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = ref.watch(searchQueryProvider).isNotEmpty;

    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onChanged: ref.read(searchQueryProvider.notifier).update,
      decoration: InputDecoration(
        hintText: 'Search causes',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: hasQuery
            ? IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Clear search',
                onPressed: () {
                  _controller.clear();
                  ref.read(searchQueryProvider.notifier).clear();
                },
              )
            : null,
      ),
    );
  }
}
