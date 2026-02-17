/**
 * <h1>Program Four</h1>
 *
 * @author  Sam Whitlock
 * @version 1.0.1
 * @since   2026-02-17
 */

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        // Getting and parsing the students
        ArrayList<Student> students = parseFileForStudents(getFile());

        // Displaying how many students were found
        System.out.println("There were " + students.size() + " Students found in this file.\n");

        // Sorting the students using the builtin comparason beacuse Student implements comparTo to compare name
        Collections.sort(students);

        // Labelling the table as by name
        System.out.println("Sorted by Name:");

        // Calling my display function to show a nice table of student data
        displayStudents(students);

        // Sorting the students using a comparator that compares average
        Collections.sort(students, new StudentComparatorByAverage());

        // Labelling the table as by average
        System.out.println("Sorted by Average:");

        // Calling my display function to show a nice table of student data
        displayStudents(students);
    }

    // ---------------------Display Function------------------------- 

    /**
     * Displays the student data in table format
     * @param ArrayList<Student> students An ArrayList of the Students to display
     */
    public static void displayStudents(ArrayList<Student> students) {

        // As a note, I know that this is inefficient and could be faster, but I did not want to resort the list or add too much extra logic 

        // The width of the name column in the table
        int nameWidth = "Student Name".length();

        // The width of the grades column in the table
        int gradesWidth = "No. of Grades".length();

        // The width of the average column (should never logically increase higher because the default can handle up to 999.99% which should be impossible)
        final int averageWidth = "Average".length();

        // Finding the widest entry in the table so that the table will expand dynamically
        for (Student s : students) {

            // Updating the width of the name column
            nameWidth = Integer.max(nameWidth, s.getFullName().length());

            // Updating the width of the grades columnt
            gradesWidth = Integer.max(gradesWidth, ("" + s.getTestCount()).length());

        }

        // System.out.print("The ");

        // Printing out the header
        System.out.printf("%-" + nameWidth
                + "s   %" + gradesWidth + "s   %" + averageWidth + "s %n", "Student Name",
                "No. of Grades", "Average");

        // Printing out the line separator
        System.out.println(
                String.format("%" + (nameWidth + gradesWidth + averageWidth + 7) + "s", " ").replace(" ", "-"));

        // Displaying all of the students' information
        for (Student s : students) {

            // Printing out a formatted string of the student info
            System.out.printf("%" + nameWidth + "s : %s   %" + averageWidth + ".2f %n", s.getFullName(),
                    centerString(gradesWidth, "" + s.getTestCount()), s.getAverage());

        }

        // Adding a newline to space out the tables
        System.out.println();

    }

    // ---------------------Helper Functions------------------------- 

    /**
     * A simple helper function designed to center a String for better output
     * @param int width The width of the final output String
     * @param String s The String to center
     * @return String A string with s centered surrounded by spaces
     */
    public static String centerString(int width, String s) {
        return String.format("%-" + width + "s", String.format("%" + (s.length() + (width - s.length()) / 2) + "s", s));
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

            // Checking to see if it is a legitimate file'
            try (Scanner fileReader = new Scanner(file)) {

                // If it opened, then we are good (the Scanner will automatically close)
                // Letting the user know of the successful open
                System.out.println("\nFile opened successfully\n");

                // Returning the file that we opened
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

    /**
     * Gets a path from the user and ensures that it leads to a valid .txt file, then returns the path that it found  
     * @return String The path to the file that the user gave
    */
    public static String getPath() {

        // Safely opening a scanner 
        try (Scanner input = new Scanner(System.in)) {

            // Reading the input
            System.out.println("Please input the path to the input file.\n");
            String path = input.nextLine();

            // Some simple error checking
            while (!path.endsWith(".txt")) {
                System.out.println("Make sure that the path is to a .txt file, please.");
                System.out.println("Please input the path to the input file.\n");
                path = input.nextLine();
            }

            // Returning the path to the .txt file
            return path;

        }

    }

    /**
     * Parses a File object for students and returns an ArrayList of the students found in that file
     * @return  ArrayList<Student> The students found in the file
    */
    public static ArrayList<Student> parseFileForStudents(File file) {

        // The list of the students that we are compiling
        ArrayList<Student> output = new ArrayList<>();

        // Opening the scanner to the file
        try (Scanner fileReader = new Scanner(file)) {

            // Not a while loop because I wanted a nice way to keep track of line numbers
            for (int lineNumber = 0; fileReader.hasNext(); lineNumber++) {

                // Everything is split by spaces, so we can just use split
                String[] tokens = fileReader.nextLine().split(" ");

                // Some simple error checking
                if (tokens.length < 2) {
                    System.out.printf(
                            "Bad input detected on line %d, ensure each line has at least first and last name! It has been skipped.\n",
                            lineNumber);
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

    // ---------------------Comparator------------------------- 
    public static class StudentComparatorByAverage implements Comparator<Student> {

        /**
         * Implementation of Comparator for Student object based on average
         * @param Student s1 The first student to compare
         * @param Student s2 The second student to compare
         * @return int Negative if the average of s1 is higher, positive if lower, and zero otherwise
         */
        @Override
        public int compare(Student s1, Student s2) {
            if (s1.getAverage() == s2.getAverage()) return 0;
            return s1.getAverage() > s2.getAverage() ? -1 : 1;
        }

        
    }
    

}









