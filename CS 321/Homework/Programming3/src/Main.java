/**
 * <h1>Program Three</h1>
 * This is a simple program to read from a custom file inputted by the user to then store and print
 * student data. It is built off of my Student class from my Program 2 submission
 *
 * @author  Sam Whitlock
 * @version 1.1.0
 * @since   2026-01-28
 */

import java.io.FileNotFoundException;
import java.io.File;
import java.util.Scanner;
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {

        // Getting and parsing the students
        ArrayList<Student> students = parseFileForStudents(getFile());

        // Displaying the students' information
        for (Student s : students) {
            displayStudent(s);
        }

    }


    // ---------------Helper Functions------------------------- 

    /**
     * Displays the student information
     * @param Student student The student to display
     * ! Will be moved to be a member method of Student, but that means this file will not be backwards compatible, so will be in the next version
     */
    public static void displayStudent(Student student) {
        System.out.print(student.getFullName());
        System.out.print(" has " + student.getTestCount() + " grades");
        System.out.println(" with an average of " + student.getAverage());
    }


    /**
     * Gets a path from the user and ensures that it leads to a valid .txt file, then returns a scanner  
     * that points to the file
     * @return File The file object that references the input file the user gives
*/
    public static File getFile() {

        // Getting a .txt path from the user
        String path = getPath();

        // Opening it 
        File file = new File(path);

        // Looping until we either find one or they want to quit
        while (true) {

            // Checking to see if it is a legitimate file
            try (Scanner fileReader = new Scanner(file)) {

                // If it opened, then we are good (the Scanner will automatically close)
                return file;


            } catch (FileNotFoundException e) {

                // Another input scanner so that they can give a new path
                Scanner input = new Scanner(System.in);

                // The file doesn't exist, so we need to ask for another one
                System.out.println(
                        "Unfortunately, the file was not found at that path.\nWould you like to input a different path?(y/n)\n");
                String ans = input.nextLine();

                // Validating the y/n answer
                while (!ans.equalsIgnoreCase("y") && !ans.equalsIgnoreCase("n")) {
                    System.out.println("Please only respond with a \"y\" or a \"n\"");
                    ans = input.nextLine();
                }

                // Exiting if they don't want to input another one
                if (ans.equalsIgnoreCase("n")) {

                    // Ensuring the input scanner is closed
                    input.close();

                    // Exiting the program with an error code of 1 
                    // (I googled it and apparently invalid argument in C is error code 1) 
                    System.exit(1);

                }

                // Getting a new file from the user
                file = new File(getPath());

            }

        }
    }


    // Helper function to get a path from the user
    public static String getPath() {

        // A scanner to read the input
        Scanner input = new Scanner(System.in);
    
        // Reading the input
        System.out.println("Please input the path to the input file.\n");
        String path = input.nextLine();

        // Some simple error checking
        while (!path.endsWith(".txt")) {
            System.out.println("Make sure that the path is to a .txt file, please.");
            System.out.println("Please input the path to the input file.\n");
            path = input.nextLine();
        }

        input.close();
        return path;
 
    }

    public static ArrayList<Student> parseFileForStudents(File file) {

        // The list of the students that we are compiling
        ArrayList<Student> output = new ArrayList<Student>();

        // Opening the scanner to the file
        try (Scanner fileReader = new Scanner(file)) {

                
            // Not a while loop because I wanted a nice way to keep track of line numbers
            for (int lineNumber = 0; fileReader.hasNext(); lineNumber++) {

                // Everything is split by spaces, so we can just use split
                String[] tokens = fileReader.nextLine().split(" ");

                System.out.println("Working on " + tokens[0]);

                // Some simple error checking
                if (tokens.length < 2) {
                    System.out.printf("Bad input detected on line %d, ensure each line has at least first and last name! It has been skipped.\n", lineNumber);
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
                output.add(newStudent);

            }
  
        } catch (FileNotFoundException e) {
            // This should never happen because we already checked that it works
            // Only thing I can think of is if the file was edited somehow before this function is called 
            // So we can just crash
            System.out.println("There was an error opening the file - was it renamed?");
            System.exit(2);
        }

        return output;

    }

}









