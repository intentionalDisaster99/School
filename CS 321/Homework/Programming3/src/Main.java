/**
 * <h1>Program Three</h1>
 * This is a simple program to read from a custom file inputted by the user to then store and print
 * student data. It is built off of my Student class from my Program 2 submission
 *
 * @author  Sam Whitlock
 * @version 1.0.0
 * @since   2026-01-25
 */

import java.io.FileNotFoundException;
import java.io.File;
import java.util.Scanner;
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {

        // Creating a scanner to read input
        Scanner pancake = new Scanner(System.in);

        // Reading the input
        System.out.println("Please input the path to the input file.\n");
        String path = pancake.nextLine();

        // Some simple error checking
        while (!path.endsWith(".txt")) {
            System.out.println("Make sure that the path is to a .txt file, please.");
            System.out.println("Please input the path to the input file.\n");
            path = pancake.nextLine();
        }

        // The ArrayList that we are using to store the student data
        ArrayList<Student> students = new ArrayList<>();

        // Opening the file if it exists
        File inputFile = new File(path);

        // Telling them that they have an error in the file path until we can open the file
        boolean valid = false;
        while (!valid) {

            // Trying to open the file
            try (Scanner fileReader = new Scanner(inputFile)) {

                System.out.println("Looping");
                // We got to a file, so we are good to break out after this iteration
                valid = true;

                // Because we know that there is one student on each line, we can
                // go line by line to get each student
                while (fileReader.hasNextLine()) {

                    // Now we need to parse the student

                    // Everything is split by spaces, so we can just use split
                    String[] tokens = fileReader.nextLine().split(" ");

                    System.out.println("Working on " + tokens[0]);

                    // Some simple error checking
                    if (tokens.length < 2) {
                        System.out.println("Bad input detected, ensure each line has a first and last name!");
                        return;
                    }

                    // We will create a default student that we can add data to
                    Student newStudent = new Student();

                    // The first two tokens are just the first and last name
                    newStudent.setFirstName(tokens[0]);
                    newStudent.setLastName(tokens[1]);

                    // The rest of the tokens are just test scores, so we can 
                    // simply insert the tokens parsed as doubles
                    for (int i = 2; i < tokens.length; i++) {
                        newStudent.addTest(Double.parseDouble(tokens[i]));
                    }

                    // Adding the student to the list of students
                    students.add(newStudent);

                }

            } catch (FileNotFoundException e) {

                // Prompting the user to ask if they want to try again
                System.out.println(
                        "Unfortunately, the file was not found at that path.\nWould you like to input a different path?(y/n)\n");
                String ans = pancake.nextLine();
                while (!ans.equalsIgnoreCase("y") && !ans.equalsIgnoreCase("n")) {
                    System.out.println("Please only respond with a \"y\" or a \"n\"");
                    System.out.println("Got '" + ans +"'");
                    ans = pancake.nextLine();
                }

                // Exiting if they don't want to
                if (ans.equalsIgnoreCase("n")) {
                    // Ensuring the input scanner is closed
                    pancake.close();
                    // Returning early to quit
                    return;
                }

                // Getting a new path
                System.out.println("Please input the path to the input file.\n");
                path = pancake.nextLine();

                // Some simple error checking
                while (!path.endsWith(".txt")) {
                    System.out.println("Make sure that the path is to a .txt file, please.");
                    System.out.println("Please input the path to the input file.\n");
                    path = pancake.nextLine();
                }

                // Now it will go back to the beginning of the loop to try to open it again

            }
        }

        // Closing the scanner input
        pancake.close();

        // Displaying the students' information
        for (Student s : students) {
            displayStudent(s);
        }

    }

    // Helper function to display a single student's information
    public static void displayStudent(Student student) {
        System.out.print(student.getFullName());
        System.out.print(" has " + student.getTestCount() + " grades");
        System.out.println(" with an average of " + student.getAverage());
    }

}









