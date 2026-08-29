import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/service/model/note_model.dart';
import '../service/api_servise.dart';

class NoteItemWidget extends StatefulWidget {
  final NoteModel note;
  const NoteItemWidget({super.key, required this.note});

  @override
  State<NoteItemWidget> createState() => _NoteItemWidgetState();
}

class _NoteItemWidgetState extends State<NoteItemWidget> {
  bool _isHovered = false;
  late bool isCompleted;

  void _showEditDialog() {
    final titleController = TextEditingController(text: widget.note.title);
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Note",
                style: GoogleFonts.kanit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                style: TextStyle(color: colorScheme.onPrimary),
                decoration: InputDecoration(
                  hintText: "Edit title...",
                  hintStyle: TextStyle(
                    color: colorScheme.onPrimary.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.surface, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colorScheme.surface, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.onPrimary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'CANCEL',
                      style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await ApiService.editNote(
                        widget.note.id!,
                        titleController.text,
                      );
                      if (success) {
                        setState(() {
                          widget.note.title = titleController.text;
                        });
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'APPLY',
                      style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isCompleted = widget.note.status == "Started" || widget.note.status == "Completed";

    const primaryColor = Color(0xFF6C5CE7);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: isCompleted,
              activeColor: primaryColor,
              checkColor: Colors.white,
              onChanged: (bool? newValue) async {
                if (newValue == null) return;

                setState(() {
                  isCompleted = newValue;
                  widget.note.status = newValue ? 'Completed' : 'Not Started';
                });

                bool success = await ApiService.updateStatus(
                  widget.note.id!,
                  widget.note.status
                );

                if (!success) {
                  setState(() {
                    isCompleted = !newValue;
                    widget.note.status = isCompleted ? 'Completed' : 'Not Started';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Xatolik: Status yangilanmadi")),
                  );
                }
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.note.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.onSurface,
                  decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: Colors.grey.shade500,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isHovered ? 1.0 : 0.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    color: Colors.grey.shade400,
                    onPressed: _showEditDialog,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    color: Colors.grey.shade400,
                    onPressed: () async {
                      bool success = await ApiService.deleteNote(widget.note.id!);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Muvaffaqiyatli o'chirildi")),
                        );
                        setState(() {
                          ApiService.fetchNotes();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
