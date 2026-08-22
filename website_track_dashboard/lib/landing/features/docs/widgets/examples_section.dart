import 'package:flutter/material.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/typography.dart';
import '../../../shared/widgets/code_block.dart';
import 'examples_data.dart';

class ExamplesSection extends StatefulWidget {
  const ExamplesSection({super.key});

  @override
  State<ExamplesSection> createState() => _ExamplesSectionState();
}

class _ExamplesSectionState extends State<ExamplesSection> {
  String _selectedId = 'fetch';
  String _selectedGroup = 'All';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final groups = [
      'All',
      ...{for (final example in viziApiExamples) example.group},
    ];

    final filteredExamples = viziApiExamples.where((example) {
      final matchesGroup =
          _selectedGroup == 'All' || example.group == _selectedGroup;

      final query = _query.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          '${example.label} ${example.group}'.toLowerCase().contains(query);

      return matchesGroup && matchesQuery;
    }).toList();

    final selected = _selectedExample(filteredExamples);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Examples',
          style: AppTypography.h2.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Use ViziAPI with your favorite language or framework.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'ViziAPI returns data. You control how it looks — style total '
          'visitors, active visitors, badges, cards, or custom dashboards '
          'with your own design system.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        _buildSearchField(),
        const SizedBox(height: 14),
        _buildTabRow(
          labels: groups,
          selected: _selectedGroup,
          accent: AppColors.cyan,
          onTap: (group) {
            setState(() {
              _selectedGroup = group;
            });
          },
        ),
        const SizedBox(height: 10),
        _buildTabRow(
          labels: filteredExamples.map((example) => example.label).toList(),
          selected: selected.label,
          accent: AppColors.accent,
          onTap: (label) {
            final example = filteredExamples.firstWhere(
              (item) => item.label == label,
            );

            setState(() {
              _selectedId = example.id;
            });
          },
        ),
        const SizedBox(height: 14),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 160),
          child: CodeBlock(
            key: ValueKey(selected.id),
            title: selected.filename ??
                selected.label.toLowerCase().replaceAll(' ', '_'),
            lang: selected.language,
            code: selected.code,
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard(),
      ],
    );
  }

  ExampleDefinition _selectedExample(
    List<ExampleDefinition> filteredExamples,
  ) {
    if (filteredExamples.isEmpty) {
      return viziApiExamples.first;
    }

    for (final example in filteredExamples) {
      if (example.id == _selectedId) {
        return example;
      }
    }

    return filteredExamples.first;
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _query = value;
        });
      },
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontFamily: AppTypography.fontSans,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        hintText: 'Search examples…',
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
        ),
        prefixIcon: const Icon(
          Icons.search,
          size: 18,
          color: AppColors.textMuted,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.radiusSm,
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.radiusSm,
          borderSide: const BorderSide(
            color: AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.radiusSm,
          borderSide: const BorderSide(
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }

  Widget _buildTabRow({
    required List<String> labels,
    required String selected,
    required Color accent,
    required ValueChanged<String> onTap,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++) ...[
            _ExampleChip(
              label: labels[index],
              selected: selected == labels[index],
              accent: accent,
              onTap: () => onTap(labels[index]),
            ),
            if (index != labels.length - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cyanSoft,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(
          color: AppColors.cyan.withValues(alpha: 0.22),
        ),
      ),
      child: Text(
        'The response contains totalVisitors and activeVisitors. '
        'The endpoint is public and requires no authentication; '
        'replace YOUR_SITE_KEY with the site key for your website.',
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textPrimary,
          height: 1.55,
        ),
      ),
    );
  }
}

class _ExampleChip extends StatelessWidget {
  const _ExampleChip({
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.radiusSm,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: 0.14)
              : AppColors.surface,
          borderRadius: AppRadii.radiusSm,
          border: Border.all(
            color: selected
                ? accent.withValues(alpha: 0.65)
                : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontSans,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
