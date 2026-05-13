import 'package:arts_and_culture/api/my_classes.dart';
import 'package:arts_and_culture/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyClassesScreen extends StatefulWidget {
  const MyClassesScreen({super.key});

  @override
  State<MyClassesScreen> createState() => _MyClassesScreenState();
}

class _MyClassesScreenState extends State<MyClassesScreen> {
  List<StudentClass> _classes = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error   = null;
    });
    try {
      final classes = await getMyClasses();
      if (!mounted) return;
      setState(() {
        _classes = classes;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error   = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeClasses = _classes.where((c) => !c.isArchived).toList();
    final pastClasses = _classes.where((c) => c.isArchived).toList();

    return Scaffold(
      appBar: AppBar(title: const Text(myClassesTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: _classes.isEmpty
                      ? _buildEmpty()
                      : ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          children: [
                            if (activeClasses.isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Text('Active Classes',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              ...activeClasses.map((sc) => _ClassCard(studentClass: sc)),
                            ],
                            
                            if (pastClasses.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Text('Past Classes',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                              ),
                              Opacity(
                                opacity: 0.75,
                                child: Column(
                                  children: pastClasses
                                      .map((sc) => _ClassCard(studentClass: sc))
                                      .toList(),
                                ),
                              ),
                            ]
                          ],
                        ),
                ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(_error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _load, child: const Text('Retry')),
        ]),
      ),
    );
  }

  Widget _buildEmpty() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 120),
        Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.school_outlined, size: 56, color: Colors.grey),
            SizedBox(height: 12),
            Text(noClassesMessage,
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          ]),
        ),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  final StudentClass sc;
  const _ClassCard({required StudentClass studentClass}) : sc = studentClass;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 3,
      shadowColor: scheme.onSecondary,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: sc.isArchived ? Colors.grey.withValues(alpha: 0.3) : scheme.onSurface.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: sc.title, 
                      style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)
                    ),
                    if (sc.section.isNotEmpty)
                      TextSpan(
                        text: ' (${sc.section})',
                        style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant)
                      ),
                  ]
                )
              ),
            ),
            _StatusBadge(met: sc.overallMet),
          ]),
          const SizedBox(height: 2),
          Text('${sc.semester} ${sc.schoolYear}',
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),
          if (sc.teacher.isNotEmpty)
            Text(sc.teacher,
                style:
                    TextStyle(color: scheme.onSurfaceVariant, fontSize: 13)),

          const SizedBox(height: 12),
          if (sc.hasRequired) ...[
            _ProgressRow(
              label: 'Required Events',
              attended: sc.reqAttended,
              target: sc.reqTarget,
              met: sc.reqMet,
              color: sc.reqMet ? Colors.green : scheme.primary,
            ),
            const SizedBox(height: 10),
          ],
          if (sc.hasMinimum) ...[
            _ProgressRow(
              label: sc.hasRequired
                  ? 'Recital Performances (beyond required)'
                  : 'Events Attended',
              attended: sc.extraCount,
              target: sc.extraTarget,
              met: sc.extraMet,
              color: sc.extraMet ? Colors.green : Colors.teal,
            ),
            const SizedBox(height: 10),
          ],
          if (sc.events.isNotEmpty) ...[
            const Divider(height: 16),
            ...sc.events.map((e) => _EventRow(event: e)),
          ] else
            Text(
              noRequiredEventsMessage,
              style:
                  TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
            ),
        ]),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final int attended;
  final int target;
  final bool met;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.attended,
    required this.target,
    required this.met,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pct = target > 0 ? (attended / target).clamp(0.0, 1.0) : 0.0;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface)),
        Row(children: [
          Text('$attended / $target',
              style:
                  TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
          const SizedBox(width: 4),
          Icon(
            met ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: met ? Colors.green : scheme.onSurfaceVariant,
          ),
        ]),
      ]),
      const SizedBox(height: 4),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: pct,
          minHeight: 8,
          backgroundColor: scheme.onSurface.withValues(alpha: 0.12),
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
      if (!met) ...[
        const SizedBox(height: 2),
        Text(
          '${(target - attended).clamp(0, target)} more needed',
          style: const TextStyle(fontSize: 11, color: Colors.deepOrange),
        ),
      ],
    ]);
  }
}

class _EventRow extends StatelessWidget {
  final ClassEventStatus event;
  const _EventRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    String formattedDate = event.eventDate;
    try {
      formattedDate =
          DateFormat('E, MMM d').format(DateTime.parse(event.eventDate));
    } catch (_) {}

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(
            event.attended
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            color: event.attended ? Colors.green : scheme.onSurfaceVariant,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(
                  event.eventName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: event.attended
                        ? scheme.onSurface
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (!event.required)
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    // surfaceContainerHighest adapts in both light and dark
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Text('Recital',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal)),
                ),
              if (event.required)
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    // surfaceContainerHighest adapts in both light and dark
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text('Required',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.red)),
                ),
            ]),
            Text(
              [
                formattedDate,
                if (event.eventTime != null &&
                    event.eventTime!.isNotEmpty)
                  _formatTime(event.eventTime!),
                if (event.eventLocation.isNotEmpty) event.eventLocation,
              ].join(' · '),
              style: TextStyle(
                  fontSize: 12, color: scheme.onSurfaceVariant),
            ),
          ]),
        ),
      ]),
    );
  }

  String _formatTime(String t) {
    try {
      return DateFormat('h:mm a').format(DateFormat('HH:mm:ss').parse(t));
    } catch (_) {
      return t;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final bool met;
  const _StatusBadge({required this.met});

  @override
  Widget build(BuildContext context) {
    final bgColor = met ? Colors.green.withValues(alpha: 0.15)
                          : Colors.orange.withValues(alpha: 0.15);
    final border = met ? Colors.green : Colors.orange;
    final textColor = met ? Colors.green.shade300 : Colors.orange.shade300;

    final brightness = Theme.of(context).brightness;
    final lightText  = met ? Colors.green.shade700 : Colors.orange.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Text(
        met ? requirementMetLabel : requirementNotMetLabel,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: brightness == Brightness.dark ? textColor : lightText,
        ),
      ),
    );
  }
}