import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cmu_sbnu_vms/app.dart';
import 'package:cmu_sbnu_vms/core/constants/route_names.dart';
import 'package:cmu_sbnu_vms/core/utils/date_helpers.dart';
import 'package:cmu_sbnu_vms/core/utils/responsive.dart';
import 'package:cmu_sbnu_vms/core/utils/validators.dart';
import 'package:cmu_sbnu_vms/data/interfaces/event_repository.dart';
import 'package:cmu_sbnu_vms/data/models/event.dart';
import 'package:cmu_sbnu_vms/data/models/user.dart';
import 'package:cmu_sbnu_vms/features/auth/auth_controller.dart';
import 'package:cmu_sbnu_vms/features/events/events_controller.dart';
import 'package:cmu_sbnu_vms/shared/result.dart';

/// Event form for creating or editing events (officer/admin only).
class EventFormScreen extends StatefulWidget {
  const EventFormScreen({
    super.key,
    required this.controller,
    required this.sessionController,
    required this.authController,
    this.eventId,
  });

  final EventsController controller;
  final SessionController sessionController;
  final AuthController authController;
  final String? eventId;

  bool get isEditing => eventId != null;

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _venueController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _capacityController = TextEditingController();

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  EventAudience _selectedAudience = EventAudience.all;
  bool _isFeatured = false;
  String? _imageUrl;

  bool _submitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      widget.controller.loadDetail(widget.eventId!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _venueController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;
        final event = state.detail;

        if (widget.isEditing && event != null && _titleController.text.isEmpty) {
          _titleController.text = event.title;
          _venueController.text = event.venue;
          _descriptionController.text = event.description ?? '';
          if (event.capacity != null) {
            _capacityController.text = event.capacity.toString();
          }
          _startDate = event.start;
          _startTime = TimeOfDay.fromDateTime(event.start);
          _endDate = event.end;
          _endTime = TimeOfDay.fromDateTime(event.end);
          _selectedAudience = event.audience;
          _isFeatured = event.isFeatured;
          _imageUrl = event.imageUrl;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.isEditing ? 'Edit event' : 'Create event'),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  compact ? 16 : 24,
                  16,
                  compact ? 16 : 24,
                  100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEditing
                          ? 'Update event details'
                          : 'Create a new event for your unit',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 24),
                    _buildTitleField(),
                    const SizedBox(height: 16),
                    _buildVenueField(),
                    const SizedBox(height: 16),
                    _buildDateTimeFields(context),
                    const SizedBox(height: 16),
                    _buildAudienceDropdown(),
                    const SizedBox(height: 16),
                    _buildCapacityField(),
                    const SizedBox(height: 16),
                    _buildFeaturedSwitch(),
                    const SizedBox(height: 16),
                    _buildImageUrlField(),
                    const SizedBox(height: 16),
                    _buildDescriptionField(),
                    const SizedBox(height: 24),
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline_rounded,
                                color: Theme.of(context).colorScheme.onErrorContainer, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: _submitting ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: _submitting
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(widget.isEditing ? 'Save changes' : 'Create event'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.isEditing)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: _submitting ? null : _deleteEvent,
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          label: const Text('Delete event',
                              style: TextStyle(color: Colors.red)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleField() => TextFormField(
        controller: _titleController,
        enabled: !_submitting,
        textInputAction: TextInputAction.next,
        maxLength: 160,
        decoration: const InputDecoration(
          labelText: 'Title *',
          hintText: 'e.g., Monthly Training Session',
          prefixIcon: Icon(Icons.title_rounded),
        ),
        validator: (v) => Validators.required(v, fieldName: 'Title') ??
            Validators.length(v, max: 160, fieldName: 'Title'),
      );

  Widget _buildVenueField() => TextFormField(
        controller: _venueController,
        enabled: !_submitting,
        textInputAction: TextInputAction.next,
        maxLength: 200,
        decoration: const InputDecoration(
          labelText: 'Venue *',
          hintText: 'e.g., CMU Gymnasium',
          prefixIcon: Icon(Icons.location_on_outlined),
        ),
        validator: (v) => Validators.required(v, fieldName: 'Venue') ??
            Validators.length(v, max: 200, fieldName: 'Venue'),
      );

  Widget _buildDateTimeFields(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _submitting ? null : () => _pickDate(context, true),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start date *',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      _startDate != null
                          ? DateHelpers.formatDate(_startDate!)
                          : 'Select date',
                      style: TextStyle(
                        color: _startDate != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: _submitting ? null : () => _pickTime(context, true),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start time *',
                      prefixIcon: Icon(Icons.access_time_rounded),
                    ),
                    child: Text(
                      _startTime != null
                          ? _startTime!.format(context)
                          : 'Select time',
                      style: TextStyle(
                        color: _startTime != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _submitting ? null : () => _pickDate(context, false),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'End date *',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      _endDate != null
                          ? DateHelpers.formatDate(_endDate!)
                          : 'Select date',
                      style: TextStyle(
                        color: _endDate != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: _submitting ? null : () => _pickTime(context, false),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'End time *',
                      prefixIcon: Icon(Icons.access_time_rounded),
                    ),
                    child: Text(
                      _endTime != null
                          ? _endTime!.format(context)
                          : 'Select time',
                      style: TextStyle(
                        color: _endTime != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildAudienceDropdown() => DropdownButtonFormField<EventAudience>(
        value: _selectedAudience,
        decoration: const InputDecoration(
          labelText: 'Audience *',
          prefixIcon: Icon(Icons.group_outlined),
        ),
        items: EventAudience.values
            .map((a) => DropdownMenuItem(
                  value: a,
                  child: Text(a.wire),
                ))
            .toList(),
        onChanged: (v) => setState(() => _selectedAudience = v ?? EventAudience.all),
      );

  Widget _buildCapacityField() => TextFormField(
        controller: _capacityController,
        enabled: !_submitting,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLength: 6,
        decoration: const InputDecoration(
          labelText: 'Capacity (optional)',
          hintText: 'e.g., 50',
          prefixIcon: Icon(Icons.people_outline),
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return null;
          final n = int.tryParse(v.trim());
          if (n == null || n <= 0) return 'Enter a positive number';
          return null;
        },
      );

  Widget _buildFeaturedSwitch() => SwitchListTile(
        title: const Text('Featured event'),
        subtitle: const Text('Show prominently on dashboard'),
        value: _isFeatured,
        onChanged: _submitting ? null : (v) => setState(() => _isFeatured = v),
        contentPadding: EdgeInsets.zero,
      );

  Widget _buildImageUrlField() => TextFormField(
        initialValue: _imageUrl,
        enabled: !_submitting,
        textInputAction: TextInputAction.next,
        maxLength: 500,
        decoration: const InputDecoration(
          labelText: 'Image URL (optional)',
          hintText: 'https://example.com/image.jpg',
          prefixIcon: Icon(Icons.image_outlined),
        ),
        onChanged: (v) => _imageUrl = v.trim().isEmpty ? null : v.trim(),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return null;
          if (!v.trim().startsWith('http://') && !v.trim().startsWith('https://')) {
            return 'Enter a valid URL starting with http:// or https://';
          }
          return Validators.safeText(v, max: 500, fieldName: 'Image URL');
        },
      );

  Widget _buildDescriptionField() => TextFormField(
        controller: _descriptionController,
        enabled: !_submitting,
        maxLines: 4,
        maxLength: 2000,
        decoration: const InputDecoration(
          labelText: 'Description (optional)',
          hintText: 'Describe the event...',
          prefixIcon: Icon(Icons.description_outlined),
          alignLabelWithHint: true,
        ),
        validator: (v) => Validators.length(v, max: 2000, fieldName: 'Description'),
      );

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initial = isStart ? _startDate : _endDate;
    final first = DateTime.now().subtract(const Duration(days: 365));
    final last = DateTime.now().add(const Duration(days: 365 * 2));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: first,
      lastDate: last,
    );
    if (picked != null && mounted) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial ?? TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate() || _submitting) return;

    final startDate = _startDate;
    final startTime = _startTime;
    final endDate = _endDate;
    final endTime = _endTime;

    if (startDate == null || startTime == null) {
      setState(() => _errorMessage = 'Please select start date and time');
      return;
    }
    if (endDate == null || endTime == null) {
      setState(() => _errorMessage = 'Please select end date and time');
      return;
    }

    final start = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    ).toUtc();
    final end = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endTime.hour,
      endTime.minute,
    ).toUtc();

    if (!end.isAfter(start)) {
      setState(() => _errorMessage = 'End time must be after start time');
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      final draft = EventDraft(
        title: _titleController.text.trim(),
        venue: _venueController.text.trim(),
        start: start,
        end: end,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        capacity: _capacityController.text.trim().isEmpty
            ? null
            : int.parse(_capacityController.text.trim()),
        audience: _selectedAudience,
        imageUrl: _imageUrl,
        isFeatured: _isFeatured,
      );

      Result result;
      if (widget.isEditing) {
        // For editing, we need the revision - simplified for now
        result = await widget.controller.updateEvent(
          eventId: widget.eventId!,
          draft: draft,
          expectedRevision: 0,
        );
      } else {
        result = await widget.controller.createEvent(draft);
      }

      if (mounted) {
        result.when(
          success: (_) => context.go(RouteNames.events),
          failure: (error) {
            setState(() {
              _submitting = false;
              _errorMessage = 'Failed to ${widget.isEditing ? "update" : "create"} event: ${error.message}';
            });
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _errorMessage = 'Failed to ${widget.isEditing ? "update" : "create"} event. Please try again.';
        });
      }
    }
  }

  Future<void> _deleteEvent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete event'),
        content: const Text(
          'Are you sure you want to delete this event? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _submitting = true);
    try {
      await widget.controller.deleteEvent(widget.eventId!);
      if (mounted) context.go(RouteNames.events);
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _errorMessage = 'Failed to delete event. Please try again.';
        });
      }
    }
  }
}