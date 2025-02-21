import 'package:flutter/material.dart';

class ControlBtn extends StatefulWidget {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final VoidCallback onTap;
  final bool isActive;

  const ControlBtn({
    super.key,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.onTap,
    required this.isActive,
  });

  @override
  State<ControlBtn> createState() => _ControlBtnState();
}

class _ControlBtnState extends State<ControlBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          //change color
          color: widget.isActive ? Colors.greenAccent : Color(0xFF1E88E5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Icon(
            //change icon
            widget.isActive ? widget.activeIcon : widget.inactiveIcon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class ControlBtn extends StatefulWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const ControlBtn({super.key, required this.icon, required this.onTap});

//   @override
//   State<ControlBtn> createState() => _ControlBtnState();
// }

// class _ControlBtnState extends State<ControlBtn> {
//   bool isActive = false;

//   void toggleColor() {
//     setState(() {
//       isActive = !isActive;
//     });
//     widget.onTap();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: toggleColor,
//       child: Container(
//         width: 50,
//         height: 50,
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: isActive ? Colors.greenAccent : Color(0xFF1E88E5),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Center(child: Icon(widget.icon, color: Colors.white)),
//       ),
//     );
//   }
// }
