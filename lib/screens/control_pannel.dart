import 'package:flutter/material.dart';

import 'package:iot/colors.dart';

class AnimationLab extends StatefulWidget {
  const AnimationLab({Key? key}) : super(key: key);

  @override
  State<AnimationLab> createState() => _AnimationLab();
}

class _AnimationLab extends State<AnimationLab> {
  String randTxt = 'some';
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Animation + $randTxt'),
        ItemSelector(
            items: const ['Rain', 'Bombard', 'Random', 'disco'],
            onChanged: (index) => setState(() {
                  randTxt = index.toString();
                })),
        const Text('Alphabet Mode')
      ],
    );
  }
}

class ItemSelector extends StatefulWidget {
  final List<String> items;
  final ValueChanged<int> onChanged;
  const ItemSelector({
    Key? key,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ItemSelector> createState() => _ItemSelectorState();
}

class _ItemSelectorState extends State<ItemSelector> {
  int selectedItem = -1;
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          return ItemsBox(
              itemName: widget.items[index],
              boxState: (selectedItem == index) ? true : false,
              ontap: () {
                setState(() {
                  isSelected = (selectedItem == index) ? true : false;
                  selectedItem = index;

                  if (selectedItem == index && isSelected == true) {
                    selectedItem = -1;
                    isSelected = false;
                  }
                  widget.onChanged(index);
                });
              });
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10);
        },
      ),
    );
  }
}

class ItemsBox extends StatelessWidget {
  final String itemName;
  final bool boxState;
  final Function() ontap;
  const ItemsBox({
    Key? key,
    required this.itemName,
    required this.boxState,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _txtTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: ontap,
      child: Ink(
        height: 40,
        width: _screenSize.width * 0.2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            itemName,
            style: _txtTheme.headline2,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: (!boxState) ? kLtGrey : null,
          gradient: (boxState)
              ? const LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight)
              : null,
        ),
      ),
    );
  }
}
