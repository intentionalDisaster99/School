
/**
* <h1>Program Two</h1>
* This is an updated simple Student class made for my CS 321 class as my submission for the Program 2 Assignment. It is built off of my Program One submission.
*
* @author  Sam Whitlock
* @version 1.1.0
* @since   2026-01-14
*/

import java.util.ArrayList;

public class Student {
    


    /**
     * Creates a new Student object based on the inputted parameters.
     * @param firstName The first name of the student
     * @param lastName The last name of the student
     */
    public Student(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.grades = new ArrayList<Double>();
    }

    
    /**
     * Creates a new default Student object. 
     * Default values:
     *      firstName -- String "unknown"
     *      lastName  -- String "unknown"
     *      grades    -- Empty ArrayList<Double>
     */
    public Student() {
        firstName = "unknown";
        lastName = "unknown";
        grades = new ArrayList<Double>();
    }
   
    /**
     * Sets the first name of the student object
     * @param newFirstName The new first name of the student
     */
    public void setFirstName(String newFirstName) {
        this.firstName = newFirstName;
    }

    /**
     * Sets the last name of the student object
     * @param newLastName The new last name of the student
     */
    public void setLastName(String newLastName) {
        lastName = newLastName;
    }

    /**
     * Sets the grades of the student
     * @param newGrade The new grade to add to the Student's record
     */
    public void addTest(double newGrade) {
        grades.add(newGrade);
    }

    /**
     * Sets the grades of the student
     * @param newGrade The new grade to add to the Student's record
     */
    public void addTest(int newGrade) {
        grades.add((double)newGrade);
    }


    /**
     * Returns a formatted name of the student in the format 
     * "lastName, firstName"
     * @returns String The formatted name of the student
     */
    public String getFullName() {
        return lastName + ", " + firstName;
    }

    /**
     * Gets the average grade of the student
     * @returns double The average grade of the student between the three grades
     */
    public double getAverage() {
        // Checking the length of grades to ensure no divide by zero error
        // Will never be an issue for this assignment, but for future usage it allows expansion
        if (grades.size() == 0) {
            return 0;
        }

        // The output of the method, will eventually be the average
        double out = 0;
        for (int i = 0; i < grades.size(); i++) {
            out += grades.get(i);
        }
        out /= (double)grades.size();
        return out;
    }

    /**
     * Gets the number of grades of the Student
     * @returns int The number of test grades the Student has 
     */
    public int getTestCount() {
        return grades.size();
    }
    

    /**
     * Returns a String defining the Student object
     * Not technically necessary for the assignment, but Professor Allen said it was wise to add them in our classes
     * @returns String String defining the Student object
     */
    public String toString() {
        return "Student: " + "firstName: \"" + firstName + "\" lastName: \"" + lastName + "\" Grades:\n"
                + grades.toString();
    }
    
    /**
     * Displays the student information in the format matching Programming 3
     */
    public void display() {
        System.out.print(this.getFullName());
        System.out.print(" has " + this.getTestCount() + " grades");
        System.out.println(" with an average of " + this.getAverage());
    }

    // Private instance variables
    private String lastName;
    private String firstName;
    private ArrayList<Double> grades; 

}
