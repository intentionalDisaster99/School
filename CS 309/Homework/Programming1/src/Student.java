
/**
* <h1>Program One</h1>
* This is a simple Student class made for my CS 321 class as my submission for the Program 1 Assignment.
*
* @author  Sam Whitlock
* @version 1.0.1
* @since   2026-01-12
*/

public class Student {
    


    /**
     * Creates a new `Student` object based on the inputted parameters.
     * @param firstName The first name of the student
     * @param lastName The last name of the student
     * @param gradeOne The first grade of the student
     * @param gradeTwo The second grade of the student
     * @param gradeThree The third grade of the student
     */
    public Student(String firstName, String lastName, int gradeOne, int gradeTwo, int gradeThree) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.grades = new double[3];
        this.grades[0] = (double)gradeOne;
        this.grades[1] = (double)gradeTwo;
        this.grades[2] = (double)gradeThree;
    }

    /**
     * Creates a new `Student` object based on the inputted parameters.
     * Uses doubles as the inputted grades to allow for more precision
     * @param firstName The first name of the student
     * @param lastName The last name of the student
     * @param gradeOne The first grade of the student
     * @param gradeTwo The second grade of the student
     * @param gradeThree The third grade of the student
     */
    public Student(String firstName, String lastName, double gradeOne, double gradeTwo, double gradeThree) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.grades = new double[3];
        this.grades[0] = gradeOne;
        this.grades[1] = gradeTwo;
        this.grades[2] = gradeThree;
    }
    
    /**
     * Creates a new default `Student` object. 
     * Default values:
     *      firstName -- String "unknown"
     *      lastName  -- String "unknown"
     *      grades    -- float[] [0.0, 0.0, 0.0]
     */
    public Student() {
        firstName = "unknown";
        lastName = "unknown";
        grades = new double[] {0.0, 0.0, 0.0};
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
     * @param gradeOne The first grade of the student
     * @param gradeTwo The second grade of the student
     * @param gradeThree The third grade of the student
     */
    public void setTestGrades(double gradeOne, double gradeTwo, double gradeThree) {
        grades[0] = gradeOne;
        grades[1] = gradeTwo;
        grades[2] = gradeThree;
    }

    /**
     * Sets the grades of the student
     * @param gradeOne The first grade of the student
     * @param gradeTwo The second grade of the student
     * @param gradeThree The third grade of the student
     */
    public void setTestGrades(int gradeOne, int gradeTwo, int gradeThree) {
        grades[0] = (double)gradeOne;
        grades[1] = (double)gradeTwo;
        grades[2] = (double)gradeThree;
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
        if (grades.length == 0) {
            return 0;
        }

        // The output of the method, will eventually be the average
        double out = 0;
        for (int i = 0; i < grades.length; i++) {
            out += grades[i];
        }
        out /= (double)grades.length;
        return out;
    }


    /**
     * Returns a String defining the Student object
     * Not technically necessary for the assignment, but Professor Allen said it was wise to add them in our classes
     * @returns String String defining the Student object
     */
    public String toString() {
        return "Student: "
                + "firstName: \"" + firstName
                + "\" lastName: \"" + lastName
                + "\" gradeOne: \"" + grades[0]
                + "\" gradeTwo: \"" + grades[1]
                + "\" gradeThree: \"" + grades[2];
    }

    // Private instance variables
    private String lastName;
    private String firstName;
    private double[] grades; 

}
