public class Counter {
    public static Integer counter {get { if(counter == null) counter = 0; counter++; return counter; } private set; }
}