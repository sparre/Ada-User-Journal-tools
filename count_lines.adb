with
  Ada.Integer_Text_IO,
  Ada.Text_IO,
  Ada.Strings.Unbounded,
  Ada.Strings.Unbounded.Text_IO;

procedure Count_Lines is
   use Ada.Integer_Text_IO, Ada.Text_IO,
       Ada.Strings.Unbounded, Ada.Strings.Unbounded.Text_IO;

   type Line_Content is (Empty, With_Content);

   Previous_Line : Line_Content := Empty;
   Empty_Lines   : Natural := 0;
   Actual_Lines  : Natural := 0;
   Input_Line    : Unbounded_String;
begin
   while not End_Of_File loop
      Get_Line (Item => Input_Line);

      if Length (Input_Line) = 0 then
         case Previous_Line is
            when Empty =>
               null;
            when With_Content =>
               Empty_Lines   := Empty_Lines + 1;
               Previous_Line := Empty;
         end case;
      else
         Actual_Lines  := Actual_Lines + (Length (Input_Line) + 39) / 40;
         Previous_Line := With_Content;
      end if;
   end loop;

   case Previous_Line is
      when Empty =>
         Put (Item => (Empty_Lines    ) / 2 + Actual_Lines, Width => 0);
      when With_Content =>
         Put (Item => (Empty_Lines + 1) / 2 + Actual_Lines, Width => 0);
   end case;
   New_Line;
end Count_Lines;
