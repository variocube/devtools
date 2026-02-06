# Java Guidelines

## Lombok

### Domain Objects (Immutable)
Use `@Value`, `@Builder`, and `@AllArgsConstructor(access = AccessLevel.PRIVATE)` for immutable domain objects:
```java
@Value
@Builder
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class User {
    @NotBlank
    String username;
    @NotNull
    Set<Permission> permissions;
}
```

### JPA Entities (Mutable)
```java
@Entity
@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@ToString(onlyExplicitlyIncluded = true)
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class UserEntity {
    @Id
    @EqualsAndHashCode.Include
    @ToString.Include
    private String id;
}
```

### Other Lombok Conventions
* Use `@RequiredArgsConstructor` for dependency injection (see Spring Boot guidelines).
* Use `@Slf4j` for logging.
* Use `val` for local variable type inference.
* Use `@Builder.Default` for default values in builders.

## Documentation
* Add Javadoc comments to all public classes, methods, and fields.
* Use single-line format for simple fields: `/** The username. */`
* Focus on what the code does, not who wrote it (no `@author`/`@since` tags).
* Document parameters with `@param`, return values with `@return`.

## Null Handling
* Use `Optional` for methods that might not return a value.
* Prefer `Optional.ofNullable(value).map(...).orElse(null)` over null checks.
* Use `@NotNull` and `@NotBlank` validation annotations on domain object fields.

## Collections
* Use `.stream().toList()` instead of `.collect(Collectors.toList())`.
* Use `EnumSet` for collections of enum values.
* Use `Map.ofEntries()` with `Map.entry()` for immutable maps:
  ```java
  Map<String, Object> params = Map.ofEntries(
      Map.entry("key1", value1),
      Map.entry("key2", value2)
  );
  ```

## Imports
* Never use wildcard imports.
* Use Jakarta EE packages (`jakarta.persistence`, `jakarta.validation`), not `javax`.
