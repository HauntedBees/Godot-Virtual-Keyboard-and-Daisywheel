# Godot 3.4 Virtual Keyboard and Daisywheel
A virtual on-screen keyboard supporting gamepad and mouse-based input as well as a daisywheel supporting gamepad input.

# Installation
Copy `addons/keyboard_daisy` into your project (final path should be `res://addons/keyboard_daisy`). In the Godot Editor, go to **Project Settings > Plugins** and enable the **Virtual Keyboard + Daisywheel** plugin. You can now add **Daisywheel** and **VirtualKeyboard** nodes to your project.

# Daisywheel
It's a daisywheel for gamepad-based text input! Just like the good old days! If you don't know what a daisywheel is, it's a gamepad-centric input method where you can use the left analog stick to choose one of eight "petals" and then press one of the four face buttons to type that letter. For some people it can be much easier and faster than manually navigating across a virtual keyboard, letter by letter, to type something.

## Inspector Properties

### Main Set
A string of at most 32 characters that will be displayed and accessible by default.

### Capital Set
A string of at most 32 characters that will be displayed and accessible when the Right Trigger (R2, RT, ZR) is held down.

### Numeric Set
A string of at most 32 characters that will be displayed and accessible when the Left Trigger (L2, LT, ZL) is held down.

### Gamepad Index
The index of the gamepad to use for input handling.

### Dead Zone
The analog stick deadzone for analog stick input to be registered.

## Signals

### key_press(key:String)
Emitted every time a valid button is pressed, with the button's value passed along with it.

### backspace
Emitted every time the backspace is activated.

### new_value(text:String)
Emitted every time the text changes (`key_press` or `backspace`).

## Customization
You can tweak any of the `.tscn` files in `res://addons/keyboard_daisy/parts/` to change the petal texture, button texture, display font, and info text.

# VirtualKeyboard
A keyboard you can click on or control with a gamepad based on **InputMap actions**.

## Inspector Properties

### Cursor Scene
A **PackedScene** that will be instanced to create the cursor. The default cursor is a **NinePatchRect** Node; any other **Control** or **Node2D** Node can be used instead, or any Scene (custom or otherwise) that has a `rect_size` property. Make sure none of the Nodes in this **PackedScene** have a **MouseFilter** value of **Stop**, or clicks won't be able to propagate down to the keys.

### Backspace Action
An **InputMap action** that, when pressed, will simulate a backspace without the user having to navigate to/click the **Delete Special Option** (see below). If left blank, the user *must* use the **Delete Special Option** (if available) to delete characters.

### Sections
An array of strings, where each character in the string will be a key on a section in the virtual keyboard. If you just want one keyboard with no separation into different sections, just use a one-item array.

### Columns per Section
How many columns each section of the keyboard will be.

### Split into Sections
If set to 0, all sections will be visible at all times. Otherwise, only `split_into_sections` sections will be shown onscreen at a time, and the user will need to press the `Switch` key (see **Special Options** below) to cycle between groups of sections.

### Min Rows
The minimum number of rows each section should have in it. Empty rows will be filled with empty disabled keys.

### Special Options
Special keys to show up at the bottom of the last visible section. Special keys are:
 - **Space**: Add a space character.
 - **Delete**: Delete the last character.
 - **Confirm**: Emit the **confirm** signal to signify that the player is done typing.
 - **Switch**: Switch between different section groups. This is useless if the **Split into Sections** value is 0 and necessary if it isn't.

### Separate Special Options
If `true`, the special options will be given their own row in the last visible section. If `false`, the keyboard will try to add the special options to the last row in the last visible section. If there are more special options available than there are empty keys in the last row, this will not work, so `true` is necessary in this case.

### Confirm Name
The text to display in the special **Confirm** button, if this button is specified in **Special Options**.

### Space Name
The text to display in the special **Space** button, if this button is specified in **Special Options**.

### Delete Name
The text to display in the special **Delete** button, if this button is specified in **Special Options**.

### Switch Names
The texts to display in the special **Switch** buttons, if **Split into Sections** has a nonzero value and the button is specified in **Special Options**. There **must** be exactly `ceil(sections.size() / split_into_sections)` names in this array, with each name referencing the content of the *next* group. For example, if you have three sections - lowercase letters, uppercase letters, and numbers, and a **Split into Sections** value of 1, the **Switch Names** value might be something like `["ABC", "123", "abc"]`, indicating that when on group 0 (lowercase letters), the next section is uppercase letters, when on group 1 the next section is numbers, and when on group 2 the next section is lowercase letters.

## Signals

### key_press(key:String)
Emitted every time a valid button is pressed, with the button's value passed along with it.

### backspace
Emitted every time the backspace is activated.

### new_value(text:String)
Emitted every time the text changes (`key_press` or `backspace`).

### confirm(text:String)
Emitted when the **Confirm Special Option** is pressed, with the full value of text typed passed along with it.

## Customization
With the exception of the cursor, the **VirtualKeyboard** is built entirely with **HBoxContainer**, **VBoxContainer**, **Button**, and **VSeparator** Nodes, and as such, the **Theme** and **Theme Overrides** values in the **Control** section of the **Inspector** can be used to customize the styles of the keyboard, as seen in the `KeyboardExample2.tscn` example scene. The cursor can be replaced with the **Cursor Scene** property in the **Inspector**, as described above.

# Example Scenes

### DaisyExample.tscn
An example of the daisywheel. Requires a connected gamepad to use.

### KeyboardExample1.tscn
A basic three-section keyboard.

### KeyboardExample2.tscn
A basic two-section keyboard with a custom **Theme** highlighting the ability to customize the keyboard's interface.

### KeyboardExample3.tscn
A single-section keyboard that can switch between letters and numbers/punctuation using the **Switch**-related functionalities.

### KeyboardExample4.tscn
A two-section keyboard that can switch between various groups using the **Switch**-related functionalities.

# License

Copyleft, but, like, whatever. If you've read this far and you're some new indie gamedev or something who really thinks this code will help you but for some reason you're very determined not to open source your game for whatever reason, I think that's weird but realistically don't care. If your game or project makes less than $1,000 or something, you can interpret this as me granting you a license to use this code in your proprietary game (with credit). If your project makes more than that, either release its source under a license compatible with the AGPLv3, take my code out of your project, or send me ten bucks.

The font [Ulagadi Sans](https://fontlibrary.org/en/font/ulagadi-sans) is licensed under the [SIL Open Font License](https://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=OFL).