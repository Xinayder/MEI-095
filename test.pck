GDPC                 �                                                                         P   res://.godot/exported/133200997/export-5099af3527758b02c0b54922dcdd49f1-sum.scn �       �      1�g��YKl�w��    ,   res://.godot/global_script_class_cache.cfg                 ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�      \      6(4�d=EQ�ǮVj,       res://.godot/uid_cache.bin  @J      8       �Xr��-���y"�G64�       res://CustomLabel.gd0      H      �Z�3pԟ]D��?       res://controller_sum.gd               0ngX���"�z���       res://icon.svg  �9      N      ]��s�9^w/�����       res://icon.svg.import   �      �       r�m���X�[���=#       res://project.binary�J      �      �DrW��\����;�i�       res://sum.tscn.remap�9      `       B�jT䥯DQ�.�IG       res://sum_controller.gd �            �D���&�vK_C�n,�    Q��list=Array[Dictionary]([])
A#.$�extends Control

var total_value = 0
var values = []
var current_idx = 0
var progressBar
var tween
var pseudocodeLbl
var arrayLbl

var pseudocode_lines = [
	"function Sum(N, A, sum)",
	"\tsum = 0",
	"\tloop i=1 to N",
	"\t\tsum = sum + A(i)",
	"\tend of loop",
	"end of function"
]

func _randomize_values():
	values = []
	
	for i in range(10):
		var value = randi_range(1, 20)
		total_value += value
		values.append(value)
	
	if progressBar:
		progressBar.max_value = total_value
		progressBar.value = 0
	
	if arrayLbl:
		arrayLbl.append_text("A = [")
		for idx in range(values.size()):
			var num = values[idx]
			arrayLbl.append_text(str(num))
			if idx < len(values) - 1:
				arrayLbl.append_text(", ")
			else:
				arrayLbl.append_text("]")

# Called when the node enters the scene tree for the first time.
func _ready():
	arrayLbl = RichTextLabel.new()
	arrayLbl.position = Vector2(0, 25)
	arrayLbl.size = Vector2(300, 50)
	add_child(arrayLbl)
	
	progressBar = ProgressBar.new()
	progressBar.size = Vector2(300, 20)
	progressBar.position = Vector2(0, 50)
	progressBar.max_value = total_value
	progressBar.value = 0
	progressBar.show_percentage = true
	add_child(progressBar)
	
	_randomize_values()

	var button = Button.new()
	button.position = Vector2(0, 100)
	button.text = "Add progress"
	button.pressed.connect(self._on_button_pressed)
	add_child(button)
	
	

	pseudocodeLbl = RichTextLabel.new()
	pseudocodeLbl.bbcode_enabled = true
	pseudocodeLbl.position = Vector2(0, 150)
	pseudocodeLbl.fit_content = true
	pseudocodeLbl.size = Vector2(200, 50)
	
	for line in pseudocode_lines:
		pseudocodeLbl.append_text(line)
		pseudocodeLbl.newline()
	
	add_child(pseudocodeLbl)

func _highlight_line(linenumber, color):
	var lines = pseudocodeLbl.text.split("\n")

	if len(lines) < 1:
		return

	for line in lines:
		if pseudocode_lines[linenumber] == line:
			pseudocodeLbl.append_text("[color=%s]%s[/color]" % [color, line])
		else:
			pseudocodeLbl.append_text(line)
		pseudocodeLbl.newline()

func _dehighlight_line():
	#var lines = label.text.split('\n')
	pseudocodeLbl.clear()

	for line in pseudocode_lines:
		pseudocodeLbl.append_text(line)
		pseudocodeLbl.newline()



func _on_button_pressed():
	if current_idx < len(values):
		var value = values[current_idx]
		_highlight_line(2, "orange")

		if tween:
			tween.kill()

		tween = create_tween()
		tween.tween_property(progressBar, "value", progressBar.value + value, 1)

		_highlight_line(3, "red")

		current_idx += 1

		await tween.finished
		_dehighlight_line()
	else:
		_highlight_line(4, "red")
		#pseudocodeLbl.text = "function Sum(N, A, sum)\n\tsum = 0\n\tloop i=1 to N\n\t\tsum = sum + A(i)\n\t[color=red]end of loop[/color]\nend of function"
		await get_tree().create_timer(0.5).timeout
		#pseudocodeLbl.text = "function Sum(N, A, sum)\n\tsum = 0\n\tloop i=1 to N\n\t\tsum = sum + A(i)\n\tend of loop\n[color=red]end of function[/color]"
		_highlight_line(5, "red")

		tween = create_tween()
		tween.tween_property(progressBar, "value", 0, 1)
		await tween.finished
		current_idx = 0
		_dehighlight_line()
4t���#�E�$extends RichTextLabel

func _get_lines():
    return self.text.split("\n")

func highlight_line(line_no, color):
    var lines = _get_lines()
    clear()

    for i in range(len(lines)):
        if i == line_no:
            append_text("[color=%s]%s[/color]" % [color, lines[i]])
        else:
            append_text(lines[i])

p �P /GST2   �   �      ����               � �        $  RIFF  WEBPVP8L  /������!"2�H�l�m�l�H�Q/H^��޷������d��g�(9�$E�Z��ߓ���'3���ض�U�j��$�՜ʝI۶c��3� [���5v�ɶ�=�Ԯ�m���mG�����j�m�m�_�XV����r*snZ'eS�����]n�w�Z:G9�>B�m�It��R#�^�6��($Ɓm+q�h��6�5��I��'���F�"ɹ{�p����	"+d������M�q��� .^>и��6��a�q��gD�h:L��A�\D�
�\=k�(���_d2W��dV#w�o�	����I]�q5�*$8Ѡ$G9��lH]��c�LX���ZӞ3֌����r�2�2ؽL��d��l��1�.��u�5�!�]2�E��`+�H&�T�D�ި7P��&I�<�ng5�O!��͙������n�
ؚѠ:��W��J�+�����6��ɒ�HD�S�z�����8�&�kF�j7N�;YK�$R�����]�VٶHm���)�rh+���ɮ�d�Q��
����]	SU�9�B��fQm]��~Z�x.�/��2q���R���,snV{�7c,���p�I�kSg�[cNP=��b���74pf��)w<:Ŋ��7j0���{4�R_��K܅1�����<߁����Vs)�j�c8���L�Um% �*m/�*+ �<����S��ɩ��a��?��F�w��"�`���BrV�����4�1�*��F^���IKJg`��MK������!iVem�9�IN3;#cL��n/�i����q+������trʈkJI-����R��H�O�ܕ����2
���1&���v�ֳ+Q4蝁U
���m�c�����v% J!��+��v%�M�Z��ꚺ���0N��Q2�9e�qä�U��ZL��䜁�u_(���I؛j+0Ɩ�Z��}�s*�]���Kܙ����SG��+�3p�Ei�,n&���>lgC���!qյ�(_e����2ic3iڦ�U��j�q�RsUi����)w��Rt�=c,if:2ɛ�1�6I�����^^UVx*e��1�8%��DzR1�R'u]Q�	�rs��]���"���lW���a7]o�����~P���W��lZ�+��>�j^c�+a��4���jDNὗ�-��8'n�?e��hҴ�iA�QH)J�R�D�̰oX?ؿ�i�#�?����g�к�@�e�=C{���&��ށ�+ڕ��|h\��'Ч_G�F��U^u2T��ӁQ%�e|���p ���������k	V����eq3���8 � �K�w|�Ɗ����oz-V���s ����"�H%* �	z��xl�4��u�"�Hk�L��P���i��������0�H!�g�Ɲ&��|bn�������]4�"}�"���9;K���s��"c. 8�6�&��N3R"p�pI}��*G��3@�`��ok}��9?"@<�����sv� ���Ԣ��Q@,�A��P8��2��B��r��X��3�= n$�^ ������<ܽ�r"�1 �^��i��a �(��~dp-V�rB�eB8��]
�p ZA$\3U�~B�O ��;��-|��
{�V��6���o��D��D0\R��k����8��!�I�-���-<��/<JhN��W�1���H�#2:E(*�H���{��>��&!��$| �~�\#��8�> �H??�	E#��VY���t7���> 6�"�&ZJ��p�C_j���	P:�a�G0 �J��$�M���@�Q��[z��i��~q�1?�E�p�������7i���<*�,b�е���Z����N-
��>/.�g�'R�e��K�)"}��K�U�ƹ�>��#�rw߶ȑqF�l�Ο�ͧ�e�3�[䴻o�L~���EN�N�U9�������w��G����B���t��~�����qk-ί�#��Ξ����κ���Z��u����;{�ȴ<������N�~���hA+�r ���/����~o�9>3.3�s������}^^�_�����8���S@s%��]K�\�)��B�w�Uc۽��X�ǧ�;M<*)�ȝ&����~$#%�q����������Q�4ytz�S]�Y9���ޡ$-5���.���S_��?�O/���]�7�;��L��Zb�����8���Guo�[''�،E%���;����#Ɲ&f��_1�߃fw�!E�BX���v��+�p�DjG��j�4�G�Wr����� 3�7��� ������(����"=�NY!<l��	mr�՚���Jk�mpga�;��\)6�*k�'b�;	�V^ݨ�mN�f�S���ն�a���ϡq�[f|#U����^����jO/���9͑Z��������.ɫ�/���������I�D��R�8�5��+��H4�N����J��l�'�כ�������H����%"��Z�� ����`"��̃��L���>ij~Z,qWXo�}{�y�i�G���sz�Q�?�����������lZdF?�]FXm�-r�m����Ф:�З���:}|x���>e������{�0���v��Gş�������u{�^��}hR���f�"����2�:=��)�X\[���Ů=�Qg��Y&�q�6-,P3�{�vI�}��f��}�~��r�r�k�8�{���υ����O�֌ӹ�/�>�}�t	��|���Úq&���ݟW����ᓟwk�9���c̊l��Ui�̸~��f��i���_�j�S-|��w�R�<Lծd�ٞ,9�8��I�Ү�6 *3�ey�[�Ԗ�k��R���<������
g�R���~��a��
��ʾiI9u����*ۏ�ü�<mԤ���T��Amf�B���ĝq��iS��4��yqm-w�j��̝qc�3�j�˝mqm]P��4���8i�d�u�΄ݿ���X���KG.�?l�<�����!��Z�V�\8��ʡ�@����mK�l���p0/$R�����X�	Z��B�]=Vq �R�bk�U�r�[�� ���d�9-�:g I<2�Oy�k���������H�8����Z�<t��A�i��#�ӧ0"�m�:X�1X���GҖ@n�I�겦�CM��@������G"f���A$�t�oyJ{θxOi�-7�F�n"�eS����=ɞ���A��Aq�V��e����↨�����U3�c�*�*44C��V�:4�ĳ%�xr2V�_)^�a]\dZEZ�C 
�*V#��	NP��\�(�4^sh8T�H��P�_��}��.��[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://baieeraenpn1h"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 *L�CP�5���+extends Control

var total_value = 0
var values = []

var current_idx = 0
var sum = 0

var tween

func _ready():
	_regenerate_values()
	$OptionsButton.get_popup().id_pressed.connect(self._on_options_button_pressed)
	$ReadButton.pressed.connect(self._on_read_button_pressed)
	$RunButton.pressed.connect(self._on_run_button_pressed)

func _on_run_button_pressed():
	if current_idx < len(values):
		if tween:
			if tween.is_running():
				return
			tween.kill()
		
		tween = create_tween()
		
		var value = values[current_idx]
		
		sum += value
		await tween.tween_property($ProgressBar, "value", value, 1).as_relative()
		
		$SumLabel.clear()
		$SumLabel.append_text("sum = %d, i = %d" % [sum, current_idx + 1])
		
		current_idx += 1

func _on_options_button_pressed(id):
	if id == 0:
		_regenerate_values()

func _on_read_button_pressed():
	$DescriptionDialog.show()

func _regenerate_values():
	values = []
	
	$ArrayLabel.clear()
	$ArrayLabel.append_text("A = [")
	
	for i in range(10):
		var value = randi_range(1, 20)
		total_value += value
		values.append(value)
	
	$ProgressBar.max_value = total_value
	
	for idx in range(values.size()):
			var num = values[idx]
			$ArrayLabel.append_text(str(num))
			if idx < len(values) - 1:
				$ArrayLabel.append_text(", ")
			else:
				$ArrayLabel.append_text("]")
�&�RSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://sum_controller.gd ��������      local://PackedScene_2n8hj          PackedScene          	         names "   1      Control    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    script    ProgressBar    offset_left    offset_top    offset_right    offset_bottom    ArrayLabel    text    fit_content    scroll_active    shortcut_keys_enabled    RichTextLabel 	   SumLabel    OptionsButton    flat    item_count    popup/item_0/text    popup/item_0/id    popup/item_1/text    popup/item_1/id    popup/item_2/text    popup/item_2/id    popup/item_2/separator    popup/item_3/text    popup/item_3/id    MenuButton    ReadButton    Button 
   RunButton    PseudocodeLabel    anchor_left    bbcode_enabled    DescriptionDialog 	   position    size    mode 
   transient    unresizable 	   min_size 	   max_size    dialog_autowrap    AcceptDialog    	   variants    (                    �?                           �A     �C     <B     HB     �B   $   A = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]                   �B     �B      sum = 0, i = 0
      QC     �B    ��C     C   	   Options
             Regenerate values              Reset           
   Read more      �B     GC     �B   	   Run step      \�     ��     C   `   function Sum(N, A, sum)
	sum = 0
	loop i=1 to N
		sum = sum + A(i)
	end of loop
end of function -      (   -   �  �        B   �  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut eleifend rhoncus ligula, sed tristique nibh luctus vel. Nulla molestie lectus eros, ac venenatis metus dapibus at. Sed vel nunc fermentum, eleifend massa vel, congue est. Nunc dapibus feugiat commodo. Nullam pulvinar et justo vel aliquam. Etiam ultrices lobortis rhoncus. Nullam velit ante, commodo sed ante eu, bibendum congue justo. Vestibulum id posuere velit, eget viverra orci. Vestibulum ultricies mi ut ultricies lacinia. Nullam non diam et nisi interdum malesuada.

Pellentesque egestas nulla ut molestie feugiat. Suspendisse potenti. Morbi consectetur justo tellus, ac sagittis dolor tristique nec. Etiam volutpat neque vitae ligula molestie, sit amet luctus augue pretium. Curabitur vitae ornare dolor, vel accumsan augue. Aenean id sagittis felis, at consectetur nisl. Duis molestie eu lacus eu ornare. Duis gravida ut nulla eget efficitur. Maecenas eleifend lobortis tempor. Duis egestas vitae urna eu porttitor. Suspendisse accumsan dolor justo, ac ultricies risus vestibulum non. Duis orci ipsum, imperdiet ullamcorper euismod vel, feugiat eu mi. In lectus sapien, venenatis ac diam quis, laoreet viverra eros. Maecenas laoreet sit amet dui sit amet auctor. Sed finibus sed ipsum a consequat. Vivamus sem leo, vehicula ac consectetur nec, tempus finibus arcu.

Aliquam metus libero, ultricies non lobortis nec, ornare non lorem. Morbi quis nunc neque. Pellentesque tempus libero et felis tristique rutrum. Sed suscipit bibendum dui, et efficitur enim euismod at. Maecenas mattis in ante quis maximus. Vestibulum tempor nulla tincidunt est convallis venenatis. Donec diam ante, consectetur et finibus eu, aliquet at erat. Sed malesuada ex eget condimentum tincidunt. Aliquam non urna sed tortor maximus iaculis. Phasellus vitae rutrum eros. Mauris sit amet mollis elit. Quisque eget enim ac elit lobortis sollicitudin eu et nulla. Donec porttitor, est vel porttitor pellentesque, orci lectus fringilla nunc, lobortis congue nisi arcu vel dui. Integer ac leo interdum, hendrerit ante id, porta velit. Curabitur massa elit, fermentum a ligula ac, cursus pharetra dui.

Duis rhoncus velit non purus finibus, quis bibendum dui gravida. Curabitur volutpat cursus ornare. Nunc id facilisis leo. Etiam quis libero luctus, malesuada lorem a, malesuada dui. Pellentesque velit dui, sollicitudin vel leo quis, pretium vestibulum est. Aliquam erat volutpat. Ut facilisis, risus eget mollis scelerisque, lectus ipsum tincidunt lorem, non mollis dui mi ac nisl. Nullam ac ultricies mi, vestibulum dapibus est. Sed felis mi, mollis non eleifend vestibulum, tempus id tellus.

Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nullam tincidunt eros magna, porttitor fringilla enim hendrerit quis. Mauris est orci, dapibus vitae interdum non, dapibus id lacus. Donec eget eros risus. Suspendisse diam sem, maximus at convallis vitae, feugiat id ipsum. Ut in condimentum leo. Phasellus fermentum ligula pellentesque mollis efficitur. Suspendisse tristique libero nec elit blandit, eget congue augue feugiat. Duis mattis augue in tortor consequat, quis venenatis enim dignissim. Duis id nulla vulputate, lacinia turpis vel, vulputate nisl. Sed ac facilisis dolor, sit amet imperdiet augue. Morbi dapibus feugiat dui, eleifend volutpat urna sagittis eget. Phasellus dapibus turpis dui, sed maximus quam condimentum vel. Praesent in sapien eu odio lacinia gravida. Cras rhoncus diam in vehicula blandit.        node_count    
         nodes     �   ��������        ����                                                                ����         	      
                                    ����	         	      
   	            
                                             ����	         	      
                                                             ����         	      
                                                                                                       "   !   ����         	      
                                    "   #   ����         	      
                                       $   ����               %            	       
         !      "         &         #                     0   '   ����   (   $   )   %   *       +      ,      -   %   .   %   /                       ����      &      &      '             conn_count              conns               node_paths              editable_instances              version             RSRC�}�[remap]

path="res://.godot/exported/133200997/export-5099af3527758b02c0b54922dcdd49f1-sum.scn"
<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><g transform="translate(32 32)"><path d="m-16-32c-8.86 0-16 7.13-16 15.99v95.98c0 8.86 7.13 15.99 16 15.99h96c8.86 0 16-7.13 16-15.99v-95.98c0-8.85-7.14-15.99-16-15.99z" fill="#363d52"/><path d="m-16-32c-8.86 0-16 7.13-16 15.99v95.98c0 8.86 7.13 15.99 16 15.99h96c8.86 0 16-7.13 16-15.99v-95.98c0-8.85-7.14-15.99-16-15.99zm0 4h96c6.64 0 12 5.35 12 11.99v95.98c0 6.64-5.35 11.99-12 11.99h-96c-6.64 0-12-5.35-12-11.99v-95.98c0-6.64 5.36-11.99 12-11.99z" fill-opacity=".4"/></g><g stroke-width="9.92746" transform="matrix(.10073078 0 0 .10073078 12.425923 2.256365)"><path d="m0 0s-.325 1.994-.515 1.976l-36.182-3.491c-2.879-.278-5.115-2.574-5.317-5.459l-.994-14.247-27.992-1.997-1.904 12.912c-.424 2.872-2.932 5.037-5.835 5.037h-38.188c-2.902 0-5.41-2.165-5.834-5.037l-1.905-12.912-27.992 1.997-.994 14.247c-.202 2.886-2.438 5.182-5.317 5.46l-36.2 3.49c-.187.018-.324-1.978-.511-1.978l-.049-7.83 30.658-4.944 1.004-14.374c.203-2.91 2.551-5.263 5.463-5.472l38.551-2.75c.146-.01.29-.016.434-.016 2.897 0 5.401 2.166 5.825 5.038l1.959 13.286h28.005l1.959-13.286c.423-2.871 2.93-5.037 5.831-5.037.142 0 .284.005.423.015l38.556 2.75c2.911.209 5.26 2.562 5.463 5.472l1.003 14.374 30.645 4.966z" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 919.24059 771.67186)"/><path d="m0 0v-47.514-6.035-5.492c.108-.001.216-.005.323-.015l36.196-3.49c1.896-.183 3.382-1.709 3.514-3.609l1.116-15.978 31.574-2.253 2.175 14.747c.282 1.912 1.922 3.329 3.856 3.329h38.188c1.933 0 3.573-1.417 3.855-3.329l2.175-14.747 31.575 2.253 1.115 15.978c.133 1.9 1.618 3.425 3.514 3.609l36.182 3.49c.107.01.214.014.322.015v4.711l.015.005v54.325c5.09692 6.4164715 9.92323 13.494208 13.621 19.449-5.651 9.62-12.575 18.217-19.976 26.182-6.864-3.455-13.531-7.369-19.828-11.534-3.151 3.132-6.7 5.694-10.186 8.372-3.425 2.751-7.285 4.768-10.946 7.118 1.09 8.117 1.629 16.108 1.846 24.448-9.446 4.754-19.519 7.906-29.708 10.17-4.068-6.837-7.788-14.241-11.028-21.479-3.842.642-7.702.88-11.567.926v.006c-.027 0-.052-.006-.075-.006-.024 0-.049.006-.073.006v-.006c-3.872-.046-7.729-.284-11.572-.926-3.238 7.238-6.956 14.642-11.03 21.479-10.184-2.264-20.258-5.416-29.703-10.17.216-8.34.755-16.331 1.848-24.448-3.668-2.35-7.523-4.367-10.949-7.118-3.481-2.678-7.036-5.24-10.188-8.372-6.297 4.165-12.962 8.079-19.828 11.534-7.401-7.965-14.321-16.562-19.974-26.182 4.4426579-6.973692 9.2079702-13.9828876 13.621-19.449z" fill="#478cbf" transform="matrix(4.162611 0 0 -4.162611 104.69892 525.90697)"/><path d="m0 0-1.121-16.063c-.135-1.936-1.675-3.477-3.611-3.616l-38.555-2.751c-.094-.007-.188-.01-.281-.01-1.916 0-3.569 1.406-3.852 3.33l-2.211 14.994h-31.459l-2.211-14.994c-.297-2.018-2.101-3.469-4.133-3.32l-38.555 2.751c-1.936.139-3.476 1.68-3.611 3.616l-1.121 16.063-32.547 3.138c.015-3.498.06-7.33.06-8.093 0-34.374 43.605-50.896 97.781-51.086h.066.067c54.176.19 97.766 16.712 97.766 51.086 0 .777.047 4.593.063 8.093z" fill="#478cbf" transform="matrix(4.162611 0 0 -4.162611 784.07144 817.24284)"/><path d="m0 0c0-12.052-9.765-21.815-21.813-21.815-12.042 0-21.81 9.763-21.81 21.815 0 12.044 9.768 21.802 21.81 21.802 12.048 0 21.813-9.758 21.813-21.802" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 389.21484 625.67104)"/><path d="m0 0c0-7.994-6.479-14.473-14.479-14.473-7.996 0-14.479 6.479-14.479 14.473s6.483 14.479 14.479 14.479c8 0 14.479-6.485 14.479-14.479" fill="#414042" transform="matrix(4.162611 0 0 -4.162611 367.36686 631.05679)"/><path d="m0 0c-3.878 0-7.021 2.858-7.021 6.381v20.081c0 3.52 3.143 6.381 7.021 6.381s7.028-2.861 7.028-6.381v-20.081c0-3.523-3.15-6.381-7.028-6.381" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 511.99336 724.73954)"/><path d="m0 0c0-12.052 9.765-21.815 21.815-21.815 12.041 0 21.808 9.763 21.808 21.815 0 12.044-9.767 21.802-21.808 21.802-12.05 0-21.815-9.758-21.815-21.802" fill="#fff" transform="matrix(4.162611 0 0 -4.162611 634.78706 625.67104)"/><path d="m0 0c0-7.994 6.477-14.473 14.471-14.473 8.002 0 14.479 6.479 14.479 14.473s-6.477 14.479-14.479 14.479c-7.994 0-14.471-6.485-14.471-14.479" fill="#414042" transform="matrix(4.162611 0 0 -4.162611 656.64056 631.05679)"/></g></svg>
��   �v,8}�Y!   res://icon.svgj�h���7   res://sum.tscnڶ�ECFG      application/config/name         ProjectWork    application/run/main_scene         res://sum.tscn     application/config/features   "         4.0    Mobile     application/config/icon         res://icon.svg  "   display/window/size/viewport_width      �  #   display/window/size/viewport_height      �     display/window/stretch/mode         canvas_items#   rendering/renderer/rendering_method         mobile  _�(��������<