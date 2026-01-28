public class Main {
    public static void main(String[] args) {
        Student student1 = new Student("Beth", "Allen"); // use this version of constructor with no grades
        Student student2 = new Student(); // will be filled with set methods
        student2.setFirstName("Bob");

        System.out.println("Program 2 - uses hardcoded statements to set a student's data.");

        student1.addTest(100);
        student1.addTest(100);
        student2.addTest(80);
        student2.addTest(80);
        student2.addTest(86);
        student2.addTest(78);
        
        System.out.println("The two Student's data are: ");
        System.out.println(student1.getFullName() + " has " + student1.getTestCount() + " grades and an average of "
        + student1.getAverage());
        System.out.println(student2.getFullName() + " has " + student2.getTestCount() + " grades and an average of "
                + student2.getAverage());
        
    }
}