//controlling draw a bit more easily
//
//
//
//
//

#region set
//set alpha
function Func_draw_set_alpha(a)
	{
	if draw_get_alpha()!=a
		draw_set_alpha(a);
	}
//set color
function Func_draw_set_color(c)
	{
	if draw_get_color()!=c
		draw_set_color(c);
	}
//set font
function Func_draw_set_font(f)
	{
	if draw_get_font()!=f
		draw_set_font(f);
	}
//set h alignment
function Func_draw_set_halign(h)	// fa_left / fa_center / fa_right
	{
	if draw_get_halign()!=h
		draw_set_halign(h);
	}
//set v alignment
function Func_draw_set_valign(v)	// fa_top / fa_middle / fa_bottom
	{
	if draw_get_valign()!=v
		draw_set_valign(v);
	}
#endregion

#region reset
//reset alpha
function Func_draw_reset_alpha()
	{
	if draw_get_alpha()!=1
		draw_set_alpha(1);
	}
//reset color
function Func_draw_reset_color()
	{
	if draw_get_color()!=-1
		draw_set_color(-1);
	}
//reset h alignment
function Func_draw_reset_halign()
	{
	if draw_get_halign()!=fa_center
		draw_set_halign(fa_center);
	}
//reset v alignment
function Func_draw_reset_valign()
	{
	if draw_get_valign()!=fa_middle
		draw_set_valign(fa_middle);
	}
//reset all sprite specific
function Func_draw_reset_all_sprite()
	{
	Func_draw_reset_alpha();
	Func_draw_reset_color();
	}
//reset all text specific
function Func_draw_reset_all_text()
	{
	Func_draw_reset_alpha();
	Func_draw_reset_color();
	Func_draw_reset_halign();
	Func_draw_reset_valign();
	}
//reset all text specific
function Func_draw_reset_all()
	{
	Func_draw_reset_alpha();
	Func_draw_reset_color();
	Func_draw_reset_halign();
	Func_draw_reset_valign();
	}



#endregion