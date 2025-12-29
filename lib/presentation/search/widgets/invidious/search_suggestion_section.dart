import 'package:flutter/material.dart';
import 'package:fluxtube/application/search/search_bloc.dart';
import 'package:fluxtube/core/constants.dart';

class InvidiousSearchSuggestionSection extends StatelessWidget {
  const InvidiousSearchSuggestionSection({
    super.key,
    required TextEditingController textEditingController,
    required this.state,
  }) : _textEditingController = textEditingController;

  final TextEditingController _textEditingController;
  final SearchState state;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) => ListTile(
              onTap: () => _textEditingController.value = TextEditingValue(
                  text: state.invidiousSuggestionResult[index] ?? ''),
              leading: const Icon(Icons.search, size: 22),
              title: Text(
                state.invidiousSuggestionResult[index],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.north_west, size: 18),
                onPressed: () {
                  _textEditingController.value = TextEditingValue(
                      text: state.invidiousSuggestionResult[index] ?? '');
                  _textEditingController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _textEditingController.text.length),
                  );
                },
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
        separatorBuilder: (context, index) => kHeightBox5,
        itemCount: state.invidiousSuggestionResult.length);
  }
}
