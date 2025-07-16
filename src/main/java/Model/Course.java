package Model;

import Model.Assignments;
import Model.Lecture;
import java.util.ArrayList;
import java.util.List;

public class Course {
    private int idCourse;
    private String name, description,image;
    private int idTeacher;
    private List<Lecture> lectures;
    private List<Assignments> assignments;

    public Course(String name, String description, int idTeacher, String image) {
        this.name = name;
        this.description = description;
        this.idTeacher = idTeacher;
        this.image=image;
        this.lectures = new ArrayList<>();
        this.assignments = new ArrayList<>();
    }

    public int getIdCourse() {
        return idCourse;
    }

    public void setIdCourse(int idCourse) {
        this.idCourse = idCourse;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getIdTeacher() {
        return idTeacher;
    }

    public void setIdTeacher(int idTeacher) {
        this.idTeacher = idTeacher;
    }

    public List<Lecture> getLectures() {
        return lectures;
    }

    public void setLectures(List<Lecture> lectures) {
        this.lectures = lectures;
    }

    public List<Assignments> getAssignments() {
        return assignments;
    }

    public void setAssignments(List<Assignments> assignments) {
        this.assignments = assignments;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("Course{");
        sb.append("idCourse=").append(idCourse);
        sb.append(", name=").append(name);
        sb.append(", description=").append(description);
        sb.append(", idTeacher=").append(idTeacher);
        sb.append(", lectures=").append(lectures);
        sb.append(", assignments=").append(assignments);
        sb.append('}');
        return sb.toString();
    }
}