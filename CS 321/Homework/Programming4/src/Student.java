
/**
* <h1>Program Four</h1>
* This is an updated simple Student class made for my CS 321 class as my submission for the Program 4 Assignment. It is built off of my Program One submission.
*
* @author  Sam Whitlock
* @version 1.0.0
* @since   2026-02-17
*/

import java.util.ArrayList;

public class Student implements Comparable<Student> {

    /**
     * Creates a new Student object based on the inputted parameters.
     * @param firstName The first name of the student
     * @param lastName The last name of the student
     */
    public Student(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.grades = new ArrayList<>();
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
        grades = new ArrayList<>();
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
     * @return String The formatted name of the student
     */
    public String getFullName() {
        return lastName + ", " + firstName;
    }

    /**
     * Gets the average grade of the student
     * @return double The average grade of the student between the three grades
     */
    public double getAverage() {
        // Checking the length of grades to ensure no divide by zero error
        // Will never be an issue for this assignment, but for future usage it allows expansion
        if (grades.isEmpty()) {
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
     * @return int The number of test grades the Student has 
     */
    public int getTestCount() {
        return grades.size();
    }
    

    /**
     * Returns a String defining the Student object formatted to be printed as Programming 3 requires
     * @return String String defining the Student object
     */
    @Override
    public String toString() {

        // I was curious if I could do C style formatting and there is one built in
        // Technically the example has 1 digit after the decimal point for the average, but grades are generally 2 so I went with 2
        // To make it 1, you just change the %.2f to %.1f
        return String.format("%s, %s has %d grades and an average of %.2f", this.lastName, this.firstName,
                this.getTestCount(), this.getAverage());

    }
    
    /**
     * Implementation of Comparable for Student based on name
     * @param Student other The other student to compare to
     * @return int Negative if other is larger, positive if other is smaller, zero if they are equal
     */
    @Override
    public int compareTo(Student other) {

        // Strings already implement the comparison for us, so we can just compare two strings
        return this.getFullName().compareTo(other.getFullName());
        
    }
    

    // Private instance variables
    private String lastName;
    private String firstName;
    private ArrayList<Double> grades; 

}
