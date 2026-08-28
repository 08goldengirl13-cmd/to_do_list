import 'package:flutter/material.dart';
import 'package:to_do_list/service/model/note_model.dart';
import '../service/api_servise.dart';

class NoteItemWidget extends StatefulWidget {
  final NoteModel note; // O'zgaruvchi shu yerda bo'lishi kerak
  const NoteItemWidget({super.key, required this.note});

  @override
  State<NoteItemWidget> createState() => _NoteItemWidgetState();
}

class _NoteItemWidgetState extends State<NoteItemWidget> {
  bool _isHovered = false;
  late bool isCompleted; // Holatni saqlash uchun

  @override
  void initState() {
    super.initState();
    // Dastlabki holatni note'dan olamiz
    isCompleted = widget.note.status == "Completed";
  }

  @override
  Widget build(BuildContext context) {
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

                // 1. UI holatini darhol o'zgartiramiz
                setState(() {
                  isCompleted = newValue;
                  widget.note.status = newValue ? 'Completed' : 'Not Completed';
                });

                // 2. Bazaga yangilangan statusni yuboramiz (ID birinchi, Status keyin)
                bool success = await ApiService.updateStatus(
                    widget.note.id!,
                    widget.note.status
                );

                // 3. Xatolik bo'lsa ortga qaytaramiz
                if (!success) {
                  setState(() {
                    print("hello---------------");
                    isCompleted = !newValue;
                    widget.note.status = !newValue ? 'Completed' : 'Not Completed';
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
                  // Statusga qarab ustidan chizish
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    color: Colors.grey.shade400,
                    onPressed: () {},
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