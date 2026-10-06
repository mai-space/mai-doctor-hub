import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../../theme/icon_mappings.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/empty_state.dart';
import '../check_in/check_in_sheet.dart';
import '../medications/intake_widgets.dart';
import 'add_appointment_sheet.dart';
import 'appointment_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _centerKey = const ValueKey('timeline-now');

  Future<void> _addAppointment() async {
    final id = await showAddAppointmentSheet(context);
    if (id != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.homeAppointmentSaved)));
    }
  }

  void _openDetail(String id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AppointmentDetailPage(appointmentId: id),
      ),
    );
  }

  Stream<List<AppointmentSummary>>? _upcoming;
  Stream<List<AppointmentSummary>>? _past;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Streams einmalig anlegen — nicht bei jedem Build neu abonnieren.
    final repo = AppointmentRepository(DatabaseScope.of(context));
    // Minütlich neu einsortieren: Termine wechseln mit der Systemzeit
    // von „kommend“ zu „vergangen“, auch ohne Datenänderung.
    Stream<void> clock() => Stream<void>.periodic(const Duration(minutes: 1));
    _upcoming ??= repo.watchUpcomingSummaries(clock: clock());
    _past ??= repo.watchPastSummaries(clock: clock());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: StreamBuilder<List<AppointmentSummary>>(
        stream: _upcoming,
        builder: (context, upcomingSnap) {
          return StreamBuilder<List<AppointmentSummary>>(
            stream: _past,
            builder: (context, pastSnap) {
              final upcoming = upcomingSnap.data ?? const [];
              final past = pastSnap.data ?? const [];
              final empty = upcoming.isEmpty && past.isEmpty;

              return CustomScrollView(
                center: empty ? null : _centerKey,
                slivers: [
                  if (!empty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final summary = past[index];
                        return _AppointmentCard(
                          summary: summary,
                          onTap: () => _openDetail(summary.appointment.id),
                        );
                      }, childCount: past.length),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    key: empty ? null : _centerKey,
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppWordmark(
                            subtitle: context.l10n.homeWordmarkSubtitle,
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: _addAppointment,
                            icon: const Icon(Icons.add),
                            label: Text(context.l10n.homeAddAppointment),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => showCheckInSheet(context),
                                  icon: const Icon(Icons.favorite_outline),
                                  label: Text(context.l10n.homeCheckIn),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      showTodayMedicationsSheet(context),
                                  icon: const Icon(Icons.medication_outlined),
                                  label: Text(context.l10n.entityMedications),
                                ),
                              ),
                            ],
                          ),
                          if (!empty) ...[
                            const SizedBox(height: 20),
                            Text(
                              context.l10n.homeNow,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Divider(),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (empty)
                    EmptyState(
                      icon: Icons.event_available_outlined,
                      title: context.l10n.homeEmptyTitle,
                      message: context.l10n.homeEmptyMessage,
                      actionLabel: context.l10n.homeEmptyAction,
                      onAction: _addAppointment,
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final summary = upcoming[index];
                        return _AppointmentCard(
                          summary: summary,
                          onTap: () => _openDetail(summary.appointment.id),
                        );
                      }, childCount: upcoming.length),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.summary, required this.onTap});

  final AppointmentSummary summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final a = summary.appointment;
    final when = DateFormat(
      context.l10n.homeCardDateTimePattern,
    ).format(a.scheduledAt);
    final chips = [...summary.diagnosisTitles, ...summary.symptomLabels];
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          a.title?.isNotEmpty == true
                              ? a.title!
                              : summary.doctorName,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (a.status != AppointmentStatus.planned)
                        _StatusBadge(status: a.status)
                      else if (summary.isMissingReport)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            context.l10n.homeReportMissing,
                            style: const TextStyle(
                              color: AppColors.danger,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    when,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  if (a.title?.isNotEmpty == true) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          summary.doctor?.specialty != null
                              ? IconMappings.specialtyIcon(
                                  summary.doctor!.specialty!,
                                )
                              : Icons.medical_services_outlined,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            summary.doctorName,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (chips.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final chip in chips.take(4))
                          Chip(
                            label: Text(chip),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cancelled = status == AppointmentStatus.cancelled;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cancelled
            ? scheme.surfaceContainerHighest
            : scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        appointmentStatusLabel(status),
        style: TextStyle(
          color: cancelled ? scheme.onSurfaceVariant : scheme.onPrimaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
