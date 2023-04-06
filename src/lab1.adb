with Ada.Text_IO; use Ada.Text_IO;

procedure lab1 is

   num_tasks        : Integer := 10;

   can_stop_threads : array (1 .. num_tasks) of Boolean;
   arr_index : array (1 .. num_tasks) of Integer;
   arr_delay : array (1 .. num_tasks) of Duration;

   task type my_task is
      entry Start (Id : Integer; Steap : Long_Long_Integer);
   end my_task;

   task body my_task is
      this_Id    : Integer           := 0;
      this_Steap : Long_Long_Integer := 0;

      Sum         : Long_Long_Integer := 0;
      count_steap : Long_Long_Integer := 1;
   begin

      accept Start (Id : in Integer; Steap : in Long_Long_Integer) do
         this_Id    := Id;
         this_Steap := Steap;
      end Start;

      --  Put_Line("Task" & this_Id'Img & "Begin");

      loop
         Sum         := Sum + this_Steap;
         count_steap := count_steap + 1;
         exit when can_stop_threads (this_Id);
      end loop;
      delay 1.0;

      Put_Line
        ("Id " & this_Id'Img & " sum: " & Sum'Img & " count steaps: " &
         count_steap'Img);
   end my_task;

   -- break_thread

   task type break_thread;

   task body break_thread is
      a_first  : Integer := 0;
      --  a_second : Integer := 0;

      a_delay : Duration;

      k : Integer := num_tasks;
      l : Integer := num_tasks;

      j_b : Integer := 2;

      passed_time     : Duration := 0.0;
      time_sleep      : Duration := 0.0;
      real_time_sleep : Duration := 0.0;
   begin

      --sort begin

      delay 5.0;

      for i in 1 .. k loop

         l := num_tasks - i;

         for j in 1 .. l loop

            j_b := j + 1;

            if arr_delay(j) > arr_delay(j_b) then

               --swap begin

               a_first := arr_index(j);
               a_delay := arr_delay(j);

               arr_index(j) := arr_index(j_b);
               arr_delay(j) := arr_delay(j_b);

               arr_index(j) := a_first;
               arr_delay(j_b) := a_delay;

               --swap end

            end if;

         end loop;
      end loop;

      --sort end

      for i in can_stop_threads'Range loop
         time_sleep := arr_delay (i);

         real_time_sleep := time_sleep - passed_time;
         delay real_time_sleep;

         can_stop_threads(arr_index(i)) := True;

         passed_time := passed_time + time_sleep;
      end loop;

   end break_thread;


   j : Duration := 30.0;

begin

   for i in 1..num_tasks loop
      arr_index(i) := i;
      arr_delay(i) := j;
      j := j - 1.0;
   end loop;


   for index in can_stop_threads'Range loop
      can_stop_threads (index) := False;
   end loop;

   declare
      breaker : break_thread;
      tasks : array (1 .. num_tasks) of my_task;
      Steap : Long_Long_Integer := 1;
   begin
      for i in tasks'Range loop
         tasks (i).Start (i, Steap);
         Steap := Steap + 1;
      end loop;
   end;
end lab1;
