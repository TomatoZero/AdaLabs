with Ada.Text_IO, GNAT.Semaphores;
use Ada.Text_IO, GNAT.Semaphores;

with Ada.Containers.Indefinite_Doubly_Linked_Lists;
use Ada.Containers;

procedure Lab3 is
   package String_List is new Indefinite_Doubly_Linked_Lists (String);
   use String_List;

   procedure Storage(storage_size, consumer_num, provider_num, consumer_product_num, provider_product_num: in Integer) is

      Storage : List;

      access_storage :  Counting_Semaphore (1, Default_Ceiling);
      empty_storage :  Counting_Semaphore (0, Default_Ceiling);
      full_storage :  Counting_Semaphore (storage_size, Default_Ceiling);

      task type Consumer is
         entry Start (id : in Integer);
      end Consumer;

      task type Provider is
         entry Start (id : in Integer);
      end Provider;


      task body Consumer is
         id : Integer;
      begin

         accept Start ( id : in Integer) do
            Consumer.id := id;
         end Start;

         for i in 1..consumer_product_num loop

            Put_Line("Consumer #" & id'Img & " See if the storage is empty : " & i'Img);
            empty_storage.Seize;
            Put_Line("Consumer #" & id'Img & " Near the storage Item #" & i'img);
            access_storage.Seize;
            Put_Line("Consumer #" & id'Img & " In the storage Item #" & i'Img);

            declare
               item : String := First_Element (Storage);
            begin
               Put_Line ("Consumer #" & id'Img & " Take item : " & item);
            end;

            storage.Delete_First;

            Put_Line("Consumer #" & id'Img & " Near the exit Item # " & i'Img);
            access_storage.Release;
            Put_Line("Consumer #" & id'Img & " Left the storage Item # " & i'Img);
            Put_Line("Consumer #" & id'Img & " FullRelease : " & i'Img);
            full_storage.Release;

         end loop;

      end Consumer;

      task body Provider is
         id : Integer;
      begin

         accept Start (id : in Integer) do
            Provider.id := id;
         end Start;

         for i in 1 .. provider_product_num loop

            Put_Line("Producer #" & id'Img & " See if the storage is full " & i'Img);
            full_storage.Seize;
            Put_Line("Producer #" & id'Img & " Near the storage Item # " & i'Img);
            access_storage.Seize;
            Put_Line("Producer #" & id'Img & " In the storage Item # " & i'Img);

            storage.Append ("item " & i'Img);
            Put_Line ("Producer #" & id'Img & " Put item : " & i'Img);

            Put_Line("Producer #" & id'img & " Near the exit Item # " & i'Img);
            access_storage.Release;
            Put_Line("Producer #" & id'Img & " Left the storage Item # " & i'Img);
            Put_Line("Producer #" & id'img & " EmptyRelease : " & i'Img);
            empty_storage.Release;

         end loop;

      end Provider;

      consumers : array (1..consumer_num) of Consumer;
      providers : array (1..provider_num) of Provider;

   begin

      for i in 1..consumer_num loop
         consumers(i).Start(id => i);
      end loop;

      for i in 1..provider_num loop
         providers(i).Start(id => i);
      end loop;

   end Storage;

   -- seize: --
   -- Release: ++

begin
   Storage(storage_size         => 5,
           consumer_num         => 15,
           provider_num         => 6,
           consumer_product_num => 2,
           provider_product_num => 5);
end Lab3;
