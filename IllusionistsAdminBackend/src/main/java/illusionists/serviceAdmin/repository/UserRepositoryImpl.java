package illusionists.serviceAdmin.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import illusionists.serviceAdmin.entity.User;
import lombok.RequiredArgsConstructor;

import java.util.List;

import static illusionists.serviceAdmin.entity.QUser.user;
import static illusionists.serviceAdmin.entity.QServiceGroup.serviceGroup;

@RequiredArgsConstructor
public class UserRepositoryImpl implements UserRepositoryCustom {

	private final JPAQueryFactory queryFactory;

	@Override
	public List<User> findAllByUniversity(String university) {
		return queryFactory
				.selectFrom(user)
				.join(user.group, serviceGroup).fetchJoin()
				.where(serviceGroup.name.eq(university))
				.fetch();
	}
}