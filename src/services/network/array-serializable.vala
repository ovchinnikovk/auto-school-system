public Gee.ArrayList<T> try_deserialize_array<T>(Type element_type, Json.Node property_node){
    var res = new Gee.ArrayList<T>();
    try {
        foreach (var item in property_node
            .get_array()
            .get_elements()){
            var obj = (T) Json.gobject_deserialize(element_type, item);
            res.add(obj);
        }
    } catch (Error e) {
        message(@"Error deserialize_array: $(e.message)");
    }
    return res;
}

public Gee.ArrayList<int> try_deserialize_int_array(Json.Node property_node){
    var res = new Gee.ArrayList<int>();
    foreach (var item in property_node
        .get_array()
        .get_elements()){
        var obj = (int)item.get_int();
        res.add(obj);
    }
    return res;
}

public async Gee.ArrayList<User?> try_deserialize_user_array(Json.Node node) {
    var users = new Gee.ArrayList<User?>();

    foreach (var item in node.get_array().get_elements()) {
        var user = yield try_deserialize_user(item.get_object());
        users.add(user);
    }

    return users;
}

public async User? try_deserialize_user (Json.Object root) {
        var user = new User();

        user.id = (int) root.get_int_member("id");
        user.name = root.get_string_member("name");
        user.surname = root.get_string_member("surname");
        user.patronym = root.get_string_member("patronym");
        user.phone = root.get_string_member("phone");
        user.email = root.get_string_member("email");
        user.telegramId = root.get_string_member("telegramId");
        user.dateOfBirth = root.get_string_member("dateOfBirth");
        user.contract = root.get_string_member("contract");
        user.examStatus = root.get_boolean_member("examStatus");
        user.license = root.get_string_member("license");
        user.experience = (int)root.get_int_member("experience");
        user.hireDate = root.get_string_member("hireDate");
        user.enrollDate = root.get_string_member("enrollDate");
        user.is_active = root.get_boolean_member("is_active");
        user.is_approved = root.get_boolean_member("is_approved");
        user.aboutMe = root.get_string_member("aboutMe");
        user.image = root.get_string_member("image");

        if (root.has_member("roles")) {
            user.roles = new Gee.ArrayList<string?>();
            var roles_array = root.get_array_member("roles");
            roles_array.foreach_element((arr, index, node) => {
                user.roles.add(node.get_string());
            });
        }

        if (root.has_member("exam")) {
            var exam_node = root.get_object_member("exam");
            user.exam = new Exam() {
                id = (int) exam_node.get_int_member("id") ,
                date = exam_node.get_string_member("date")
            };
        }

        if (root.has_member("car")) {
            var car_node = root.get_object_member("car");
            user.car = new Car() {
                id = (int) car_node.get_int_member("id"),
                carModel = car_node.get_string_member("carModel"),
                stateNumber = car_node.get_string_member("stateNumber"),
                productionYear = car_node.get_string_member("productionYear"),
                vinNumber = car_node.get_string_member("vinNumber"),
                image = car_node.get_string_member("image"),
                carMark = new CarMark() {
                    id = (int) car_node.get_object_member("carMark").get_int_member("id"),
                    title = car_node.get_object_member("carMark").get_string_member("title")
                },
                category = new Category() {
                    id = (int)car_node.get_object_member("category").get_int_member("id"),
                    title = car_node.get_object_member("category").get_string_member("title"),
                    description = car_node.get_object_member("category").get_string_member("description")
                }
            };
        }

        if (root.has_member("category")) {
            var category_node = root.get_object_member("category");
            user.category = new Category() {
                id = (int)category_node.get_int_member("id"),
                title = category_node.get_string_member("title"),
                description = category_node.get_string_member("description")
            };
        }

        if (root.has_member("reviews")) {
            user.reviews = new Gee.ArrayList<Review?>();
            var reviews_array = root.get_array_member("reviews");
            reviews_array.foreach_element((arr, index, node) => {
                if (node.get_node_type() == Json.NodeType.NULL) {
                    user.reviews.add(null);
                } else {
                    var review_obj = node.get_object();
                    user.reviews.add(new Review() {
                        id = (int) review_obj.get_int_member("id"),
                        title = review_obj.get_string_member("title"),
                        description = review_obj.get_string_member("description")
                    });
                }
            });
        }

        if (root.has_member("courses")) {
            user.courses = new Gee.ArrayList<Course?>();
            var courses_array = root.get_array_member("courses");
            courses_array.foreach_element((arr, index, node) => {
                if (node.get_node_type() == Json.NodeType.NULL) {
                    user.courses.add(null);
                } else {
                    var course_obj = node.get_object();
                    var course = new Course() {
                        id = (int) course_obj.get_int_member("id"),
                        title = course_obj.get_string_member("title"),
                        description = course_obj.get_string_member("description"),
                        price = (int) course_obj.get_int_member("price"),
                        category = new Category() {
                            id = (int)course_obj.get_object_member("category").get_int_member("id"),
                            title = course_obj.get_object_member("category").get_string_member("title"),
                            description = course_obj.get_object_member("category").get_string_member("description")
                        },
                        lessons = new Gee.ArrayList<Lesson>(),
                        courseQuizzes = new Gee.ArrayList<CourseQuiz>()
                    };

                    if (course_obj.has_member("lessons")) {
                        var lessons_array = course_obj.get_array_member("lessons");
                        lessons_array.foreach_element((l_arr, l_index, l_node) => {
                            var lesson_obj = l_node.get_object();
                            course.lessons.add(new Lesson() {
                                id = (int) lesson_obj.get_int_member("id"),
                                title = lesson_obj.get_string_member("title"),
                                description = lesson_obj.get_string_member("description"),
                                types = lesson_obj.get_string_member("types"),
                                teacher = lesson_obj.get_string_member("teacher"),
                                date = lesson_obj.get_string_member("date"),
                                orderNumber = (int) lesson_obj.get_int_member("orderNumber"),
                                videos = new Gee.ArrayList<Video>()
                            });
                        });
                    }

                    if (course_obj.has_member("courseQuizzes")) {
                        var quizzes_array = course_obj.get_array_member("courseQuizzes");
                        quizzes_array.foreach_element((q_arr, q_index, q_node) => {
                            var quiz_obj = q_node.get_object();
                            var quiz = new CourseQuiz() {
                                id = (int) quiz_obj.get_int_member("id"),
                                question = quiz_obj.get_string_member("question"),
                                orderNumber = (int) quiz_obj.get_int_member("orderNumber") ,
                                image = quiz_obj.get_string_member("image"),
                                answers = new Gee.ArrayList<Answer>()
                            };

                            if (quiz_obj.has_member("answers")) {
                                var answers_array = quiz_obj.get_array_member("answers");
                                answers_array.foreach_element((a_arr, a_index, a_node) => {
                                    var answer_obj = a_node.get_object();
                                    quiz.answers.add(new Answer() {
                                        id = (int) answer_obj.get_int_member("id"),
                                        answerText = answer_obj.get_string_member("answerText"),
                                        status = answer_obj.get_boolean_member("status")
                                    });
                                });
                            }

                            course.courseQuizzes.add(quiz);
                        });
                    }

                    user.courses.add(course);
                }
            });
        }

        return user;
    }
